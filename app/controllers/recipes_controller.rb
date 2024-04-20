class RecipesController < ApplicationController
  include RecipesHelper

  def index
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.includes(:steps,:categories).with_attached_thumbnail.all.page(params[:page]).per(10)

    #@stamp_middles = StampMiddle.all
    StampMiddle.liked_by_user?(@recipes,current_user.id)
    StampMiddle.count_like_recipe(@recipes)
  end

  def show
    @url_recipe_show = true
    @recipe = Recipe.includes(:steps).find(params[:id])
    @comments = @recipe.comments.includes(:user, replies: [:user, {myreply: :user}]).order(created_at: :desc)
    @comment = @recipe.comments.new
    @replies = Comment.includes(:user).where.not(reply_to_id: nil)
    @parent_comments = @comments.where(parent_id:nil)
  end

  def new
    @recipe = Recipe.new

    @q = Category.ransack(params[:q])
    @categories = @q.result(distinct: true)
    @url_recipe_new = true
    set_step_build

  end

  def create
    @recipe = Recipe.new(recipe_params_carry_up_number)
    @recipe.user_id = current_user.id
    if @recipe.save
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
    @copied_recipe, @copied_recipe_steps = copy_recipe_helper(@recipe)

    @recipe = @copied_recipe
    @recipe.steps = @copied_recipe_steps
  end


  private

  # Strong Parameters
  def recipe_params
    params.require(:recipe).permit(:name, :thumbnail, :thumbnail_edited, :bio, :copy_permission, steps_attributes: [:id, :number, :process])
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
    params.require(:recipe).permit(:name, :thumbnail, :thumbnail_edited, :bio, :copy_permission, steps_attributes: [:id, :number, :process], category_ids: []).tap do |whitelisted|
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
end
