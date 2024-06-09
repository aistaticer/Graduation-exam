class RecipesController < ApplicationController
  before_action :custom_authenticate_user!
  before_action :set_recipe, only: [:edit, :update]

  include RecipesHelper
  require 'openai'

  def index
    @url_recipe_index = true;
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.includes(:steps,:genre,:menu).with_attached_thumbnail.all.page(params[:page]).per(8)

    stamp_set(@recipes)
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
    #@recipe = Recipe.new
    @recipe = Recipe.new

    set_step_build
    @recipe.ingredients.build
    @recipe.build_copied_recipe
  end

  def copy_create
    # レシピをコピーして作成する処理
    @recipe = Recipe.new(recipe_params_carry_up_number)

    @recipe.user_id = current_user.id
    
    @url_recipe_copy = true

    #自分の元になったレシピを探し出している
    @before_recipe = Recipe.includes(:steps).find(@recipe.copied_recipe.before_recipe)
    # コピーの「作り方」が同じじゃないかを確認している 同じならfalseを返す
    process_check = check_before_recipe(@before_recipe, @recipe)

    
    if @recipe.save && process_check
      original_recipe_update
      flash[:notice] = "レシピを正常に作成しました"

      #　レシピの保存に成功したらscrptによって強制的に画面遷移させてる。turboだと二つのリクエストが出てフラッシュメッセージが消えるから.
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("error", "<script>window.location = '#{recipe_path(@recipe)}';</script>")
        end
      end
    else

      # @recipe.saveの後だと設定したエラーメッセージが消えるから改めて設定している
      save_after_message_set(process_check);

      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = @recipe.errors.full_messages.join("<br>").html_safe
          render turbo_stream: turbo_stream.replace("error", partial: "shared/flash_error")
        end
      end
    end 
  end

  def create
    @recipe = Recipe.new(recipe_params_carry_up_number)

    @url_recipe_new = true

    if @recipe.save

      #　新しく保存するレシピの、オリジナルのレシピのidを保存している
      original_recipe_update
      session.delete(:recipe_params)

      flash[:notice] = "レシピを正常に作成しました"
      respond_to do |format|
        format.turbo_stream do
          # turboだと二つのリクエストが出てフラッシュメッセージが消える。だからscrptによって強制的に遷移させてる
          render turbo_stream: turbo_stream.replace("error", "<script>window.location = '#{recipe_path(@recipe)}';</script>")
        end
      end

    else

      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = @recipe.errors.full_messages.join("<br>").html_safe
          render turbo_stream: turbo_stream.replace("error", partial: "shared/flash_error")
        end
      end

    end
  end

  def edit
    @url_recipe_edit = true
  end

  def update
    if @recipe.update(recipe_params_carry_up_number)

      flash[:notice] = "レシピを更新しました"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("error", "<script>window.location = '#{recipe_path(@recipe)}';</script>")
        end
      end

    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = @recipe.errors.full_messages.join("<br>").html_safe
          render turbo_stream: turbo_stream.replace("error", partial: "shared/flash_error")
        end
      end
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_back(fallback_location: recipes_path, notice: 'レシピの削除に成功しました')
  end

  def copy_and_new

    @url_recipe_copy = true
    
    # オリジナルのレシピを検索して代入
    recipe = Recipe.find(params[:recipe_id])

    #@new_copied_recipeはコピー関連の情報を持つ子モデル
    @copied_recipe, @new_copied_recipe, @copied_recipe_ingredients = copy_recipe_helper(recipe)

    # 配列にレシピの内容を入れてhtmlにわたし、jsが受け取れるようにする。AIのため
    ai_pass_array()

  end


=begin  def copy_and_new

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
=end
  def evolution
    @recipe = Recipe.includes(:steps,:ingredients, :copied_recipe).find(params[:recipe_id])
    @url_recipe_evolution = true


    copied_recipe_ids = CopiedRecipe.where(original_recipe: @recipe.copied_recipe.original_recipe).order(:before_recipe).pluck(:recipe_id)

    recipes = Recipe.where(id: copied_recipe_ids).with_attached_thumbnail
    @recipes = copied_recipe_ids.map { |id| recipes.find { |recipe| recipe.id == id } }
    StampMiddle.count_like_recipe(@recipes)

    grouped_copied_recipe_ids = CopiedRecipe.where(original_recipe: @recipe.copied_recipe.original_recipe)
                                        .order(:before_recipe)
                                        .group_by(&:before_recipe)
                                        .transform_values { |recipes| recipes.pluck(:recipe_id) }

    @recipe_power = []
    @recipe_id = []
    @recipes.each do |recipe|
      @recipe_power.push(recipe.likes_count)
      @recipe_id.push(recipe.id)
    end
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

  def ai_pass_array()
    @recipe_name = []
    @recipe_name.push(@copied_recipe.name)
    @steps_array = []
    @copied_recipe.steps.each do|step|
      @steps_array.push(step.process)
    end
  end

  def stamp_set(recipes)
    delicious_type = StampsType.find_by(name: "Delicious")
    like_type = StampsType.find_by(name: "Like")
    StampMiddle.stamped_by_user?(recipes,current_user.id,delicious_type,like_type)
    StampMiddle.count_stamp_recipe(recipes,delicious_type,like_type)
  end

  def set_recipe
    @recipe = @recipe = Recipe.includes(:user, :steps,:ingredients,:menu,:genre).find(params[:id])
  end

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
    params.require(:recipe).permit(:name, :serving, :thumbnail, :user_id, :bio, :copy_permission, :menu_id, :genre_id,
                                   ingredients_attributes: [:id, :name, :quantity], 
                                   steps_attributes: [:id, :number, :process], 
                                   copied_recipe_attributes: [:id, :original_recipe, :before_recipe], 
                                   category_ids: [])
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
    params.require(:recipe).permit(:name, 
                                  :user_id, 
                                  :serving, 
                                  :thumbnail,
                                  :bio, 
                                  :copy_permission, 
                                  :menu_id, :genre_id, 
                                  ingredients_attributes: [:id, :name, :quantity], 
                                  steps_attributes: [:id, :number, :process], 
                                  copied_recipe_attributes: [:id, :original_recipe, :before_recipe], 
                                  category_ids: []).tap do |whitelisted|
                                    
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

  #　新しく保存するレシピの、オリジナルのレシピのidを保存している
  def original_recipe_update
    if @recipe.copied_recipe.original_recipe == nil
      @recipe.create_copied_recipe(original_recipe: @recipe.id)
    end
  end

  def check_before_recipe(before_recipe,recipe)
    recipe_processes = [];
    custom_messages = [];
    before_processes = before_recipe.steps.pluck(:process)
    @recipe.steps.each do |step|
      recipe_processes << step.process
    end

    if before_processes == recipe_processes
      return false
    end
    true
  end

  def save_after_message_set(process_check)
    if(process_check == false)
      @recipe.errors.add(:base, "作り方が完全に一致しています。一部変更してください")
    end
  end
end

