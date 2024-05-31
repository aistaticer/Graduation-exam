class RecipesController < ApplicationController
  before_action :custom_authenticate_user!
  #before_action :some_action

  include RecipesHelper
  require 'openai'

  def index
    @url_recipe_index = true;
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.includes(:steps,:genre,:menu).with_attached_thumbnail.all.page(params[:page]).per(8)

    #@stamp_middles = StampMiddle.all
    #StampMiddle.liked_by_user?(@recipes,current_user.id)
    #StampMiddle.count_like_recipe(@recipes)

    delicious_type = StampsType.find_by(name: "Delicious")
    like_type = StampsType.find_by(name: "Like")
    StampMiddle.stamped_by_user?(@recipes,current_user.id,delicious_type,like_type)
    StampMiddle.count_stamp_recipe(@recipes,delicious_type,like_type)
  end

  def show
    @url_recipe_show = true
    @recipe = Recipe.includes(:user, :steps,:ingredients,:menu,:genre).find(params[:id])
    @comments = @recipe.comments.includes(:user, replies: [:user, {myreply: :user}]).order(created_at: :desc)
    @comment = @recipe.comments.new
    @replies = Comment.includes(:user).where.not(reply_to_id: nil)
    @parent_comments = @comments.where(parent_id:nil)
  end

  def new
    @url_recipe_new = true
    @recipe = Recipe.new
    set_step_build
    @recipe.ingredients.build
    @recipe.build_copied_recipe
  end

  def create
    @recipe = Recipe.new(recipe_params_carry_up_number)

    if params[:source] == "new"
      @url_recipe_new = true
    elsif params[:source] == "copy_and_new"
      @url_recipe_copy = true
      
      #自分の元になったレシピを探し出している
      @before_recipe = Recipe.includes(:steps).find(@recipe.copied_recipe.before_recipe)

      if check_before_recipe(@before_recipe, @recipe)
      else
        return
      end

    end

    @recipe.user_id = current_user.id
    if @recipe.save
      original_recipe_update
      redirect_to recipe_path(@recipe), flash: { notice: 'レシピが正常に投稿されました。' }, allow_other_host: false
    else

      if params[:source] == "new"
        render :new, status: :unprocessable_entity

      elsif params[:source] == "copy_and_new"
        # @recipeをcopy_and_newで定義するためエラー文を変数に代入
        @error_messages = @recipe.errors.full_messages
        copy_and_new
        render :copy_and_new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_back(fallback_location: recipes_path, notice: 'レシピの削除に成功しました')
  end

  def copy_and_new

    @url_recipe_copy = true
    
    # オリジナルのレシピを検索して代入
    @recipe = Recipe.find(params[:recipe_id])

    @q = Category.ransack(params[:q])
    @categories = @q.result(distinct: true).order(:hiragana)
    others = @categories.find { |category| category.name == "その他" }
    @categories = @categories.reject { |category| category.name == "その他" } + [others] if others

    @copied_recipe, @copied_recipe_steps, @copied_recipe_categories, @copied_recipe_ingredients, @new_copied_recipe = copy_recipe_helper(@recipe)

    @copied_recipe.steps = @copied_recipe_steps
    @copied_recipe.categories = @copied_recipe_categories
    @copied_recipe.ingredients = @copied_recipe_ingredients
    @copied_recipe.copied_recipe = @new_copied_recipe

    # 配列にレシピの内容を入れてhtmlにわたし、jsが受け取れるようにする。AIのため
    @recipe_name = []
    @recipe_name.push(@copied_recipe.name)
    @steps_array = []
    @copied_recipe.steps.each do|step|
      @steps_array.push(step.process)
    end

  end

  def evolution
    @recipe = Recipe.includes(:steps,:ingredients, :copied_recipe).find(params[:recipe_id])
    @url_recipe_evolution = true

    logger.debug(@recipe.name)
    copied_recipe_ids = CopiedRecipe.where(original_recipe: @recipe.copied_recipe.original_recipe).order(:before_recipe).pluck(:recipe_id)
    logger.debug(copied_recipe_ids)
    recipes = Recipe.where(id: copied_recipe_ids).with_attached_thumbnail
    @recipes = copied_recipe_ids.map { |id| recipes.find { |recipe| recipe.id == id } }
    StampMiddle.count_like_recipe(@recipes)

    grouped_copied_recipe_ids = CopiedRecipe.where(original_recipe: @recipe.copied_recipe.original_recipe)
                                        .order(:before_recipe)
                                        .group_by(&:before_recipe)
                                        .transform_values { |recipes| recipes.pluck(:recipe_id) }
    logger.debug(grouped_copied_recipe_ids)
    #@recipes = Recipe.where(id: grouped_copied_recipe_ids)
    
    @recipe_power = []
    @recipe_id = []
    @recipes.each do |recipe|
      @recipe_power.push(recipe.likes_count)
      @recipe_id.push(recipe.id)
    end
    logger.debug("おおおお")
    logger.debug(copied_recipe_ids)
  end

  def ask_open_ai
    #使用制限のため
    user_id = current_user.id
    usage_record = UsageRecord.find_by(user_id: user_id)

    logger.debug(Date.today)
    if usage_record && usage_record.last_used_on == Date.today
      render json: { content: "使用制限に到達しました" }, status: :forbidden
      return
    end

    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    recipe_steps = params["recipe_steps"]
    recipe_name = params["recipe_name"]
    logger.debug(making(recipe_name, recipe_steps))
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", content: making(recipe_name, recipe_steps)}],
            #max_tokens: 50,
        })
    logger.debug(response.dig("choices", 0, "message", "content"))
    render json: { content: response.dig("choices", 0, "message", "content") }
  
    # 使用状況の変更
    if usage_record
      usage_record.update(last_used_on: Date.today)
    else
      UsageRecord.create(user_id: user_id, last_used_on: Date.today)
    end
  
  end

  private

  def making(name, steps)
    # 最初に料理名を含む文字列を用意する
    result = "料理名:#{name}。作り方"
    # steps 配列から最大2つの要素を取り出して、その内容とともに番号を付けて文字列に追加する
    steps.each_with_index do |step, index|
      result += " #{index + 1} #{step} "
    end
    # 文字列を閉じる
    result += "。もっと美味しくしたい。箇条書きだけ、最大二つまでで具体的に詳しく答えて。一つは材料を変えた回答を。あと敬語は長いからである調でお願い"
    # 結果の文字列を返す
    result
  end

  # Strong Parameters
  def recipe_params
    params.require(:recipe).permit(:name, :serving, :thumbnail, :thumbnail_edited, :bio, :copy_permission, :menu_id, :genre_id, ingredients_attributes: [:id, :name, :quantity], steps_attributes: [:id, :number, :process], copied_recipe_attributes: [:id, :original_recipe, :before_recipe], category_ids: [])
  end

  def set_step_build
    @process_number = 0
    6.times {
      @process_number += 1
      @recipe.steps.build
    }
  end

  def recipe_params_carry_up_number
    # まず、通常通りにparamsを取得
    params.require(:recipe).permit(:name, :serving, :thumbnail, :thumbnail_edited, :bio, :copy_permission, :menu_id, :genre_id, ingredients_attributes: [:id, :name, :quantity], steps_attributes: [:id, :number, :process], copied_recipe_attributes: [:id, :original_recipe, :before_recipe], category_ids: []).tap do |whitelisted|
      # steps_attributesがあれば、descriptionが空のものを除外
      if whitelisted[:steps_attributes]
        whitelisted[:steps_attributes].reject! { |_, step_attribute| step_attribute[:process].blank? }
  
        # descriptionが空でないsteps_attributesのnumberを繰り上げる
        whitelisted[:steps_attributes].values.each_with_index do |step_attribute, index|
          step_attribute[:number] = index + 1
        end
      end
  
      # steps_attributesが空になった場合、一つだけ残す
      if whitelisted[:steps_attributes].blank?
        whitelisted[:steps_attributes] = [{ number: 1, process: "" }]
      end

      if whitelisted[:ingredients_attributes]
        whitelisted[:ingredients_attributes].reject! { |_, ingredients_attribute| ingredients_attribute[:name].blank? }
        whitelisted[:ingredients_attributes].reject! { |_, ingredients_attribute| ingredients_attribute[:quantity].blank? }
      end

      if whitelisted[:ingredients_attributes].blank?
        whitelisted[:ingredients_attributes] = [{name: "", quantity: "" }]
      end
    end
  end

  #　新しく保存するレシピの元を辿ったオリジナルののレシピを保存している
  def original_recipe_update
    if @recipe.copied_recipe.original_recipe == nil
      @recipe.create_copied_recipe(original_recipe: @recipe.id)
    end
  end

  def check_before_recipe(before_recipe,recipe)
    recipe_processes = [];
    before_processes = before_recipe.steps.pluck(:process)
    @recipe.steps.each do |step|
      recipe_processes << step.process
    end

    if before_processes == recipe_processes
      flash.now[:alert] = "作り方が完全に一致しています。一部変更してください"
      render :new
      return false
    else 
      return true
    end
  end
end
