class RecipesController < ApplicationController
  include RecipesHelper

  def index
    @url_recipe_index = true;
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.includes(:steps,:categories).with_attached_thumbnail.all.page(params[:page]).per(10)

    #@stamp_middles = StampMiddle.all
    StampMiddle.liked_by_user?(@recipes,current_user.id)
    StampMiddle.count_like_recipe(@recipes)
  end

  def show
    @url_recipe_show = true
    @recipe = Recipe.includes(:steps,:ingredients).find(params[:id])
    @comments = @recipe.comments.includes(:user, replies: [:user, {myreply: :user}]).order(created_at: :desc)
    @comment = @recipe.comments.new
    @replies = Comment.includes(:user).where.not(reply_to_id: nil)
    @parent_comments = @comments.where(parent_id:nil)

    @recipe.steps.each do |a|
      logger.debug(a.process)
      logger.debug("あああああああああああああ")
    end
  end

  def new
    @recipe = Recipe.new
    @q = Category.ransack(params[:q])

    @categories = @q.result(distinct: true).order(:hiragana)
    others = @categories.find { |category| category.name == "その他" }
    @categories = @categories.reject { |category| category.name == "その他" } + [others] if others
    
    @url_recipe_new = true
    set_step_build
    @recipe.ingredients.build
    @recipe.build_copied_recipe
  end

  def create
    @recipe = Recipe.new(recipe_params_carry_up_number)
    @recipe.user_id = current_user.id
    if @recipe.save
      original_recipe_update
      redirect_to recipe_path(@recipe), flash: { success: 'レシピが正常に投稿されました。' }
    else
      flash.now[:danger] = 'レシピの投稿に失敗しました。'
      render :new, status: :see_other
    end
  end

  def edit
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
  end

  def copy_and_new

    @url_recipe_new = true
    @recipe = Recipe.find(params[:recipe_id])

    @q = Category.ransack(params[:q])
    @categories = @q.result(distinct: true).order(:hiragana)
    others = @categories.find { |category| category.name == "その他" }
    @categories = @categories.reject { |category| category.name == "その他" } + [others] if others

    @copied_recipe, @copied_recipe_steps, @copied_recipe_categories, @copied_recipe_ingredients = copy_recipe_helper(@recipe)


    @copied_recipe.steps = @copied_recipe_steps
    @copied_recipe.categories = @copied_recipe_categories
    @copied_recipe.ingredients = @copied_recipe_ingredients
  end

  def evolution
    @recipe = Recipe.includes(:steps,:ingredients, :copied_recipe).find(params[:recipe_id])
    @url_recipe_evolution = true

    logger.debug(@recipe.name)
    copied_recipe_ids = CopiedRecipe.where(original_recipe: @recipe.copied_recipe.original_recipe).order(:before_recipe).pluck(:recipe_id)
    @recipes = Recipe.where(id: copied_recipe_ids)

    StampMiddle.count_like_recipe(@recipes)
    
    @recipe_power = []
    @recipe_id = []
    @recipes.each do |recipe|
      @recipe_power.push(recipe.likes_count)
      @recipe_id.push(recipe.id)
    end
    logger.debug(@recipe_power)

  end


  private

  # Strong Parameters
  def recipe_params
    params.require(:recipe).permit(:name, :thumbnail, :thumbnail_edited, :bio, :copy_permission, ingredients_attributes: [:id, :name, :serving, :quantity], steps_attributes: [:id, :number, :process], copied_recipe_attributes: [:id, :original_recipe, :before_recipe], category_ids: [])
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
    params.require(:recipe).permit(:name, :thumbnail, :thumbnail_edited, :bio, :copy_permission, ingredients_attributes: [:id, :name, :serving, :quantity], steps_attributes: [:id, :number, :process], copied_recipe_attributes: [:id, :original_recipe, :before_recipe], category_ids: []).tap do |whitelisted|
      # steps_attributesがあれば、descriptionが空のものを除外
      if whitelisted[:steps_attributes]
        whitelisted[:steps_attributes].each do |key, step_attribute|
          if step_attribute[:process].blank?
            whitelisted[:steps_attributes].delete(key)
          end
        end
          # descriptionが空でないsteps_attributesのnumberを繰り上げる
        whitelisted[:steps_attributes].values.each_with_index do |step_attribute, index|
          step_attribute[:number] = index + 1
        end
      end
    end
  end

  def original_recipe_update
    if @recipe.copied_recipe.original_recipe == nil
      @recipe.create_copied_recipe(original_recipe: @recipe.id)
    end
  end
end
