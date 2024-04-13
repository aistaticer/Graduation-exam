class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(:steps).all
  end

  def show
    @recipe = Recipe.includes(:steps).find(params[:id])
  end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
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
	end

	private

  # Strong Parameters
  def recipe_params
    params.require(:recipe).permit(:name, :thumbnail, :thumbnail_edited, :bio, :copy_permission, steps_attributes: [:id, :number, :process])
  end
end
