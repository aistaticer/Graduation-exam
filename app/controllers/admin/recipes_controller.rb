class Admin::RecipesController < ApplicationController
	before_action :authenticate_user!

	def index
		@recipes = Recipe.includes(:steps,:genre,:menu).with_attached_thumbnail.all.page(params[:page]).per(8)
	end

	def destroy
		@recipe = Recipe.find(params[:id])
		@recipe.destroy
		redirect_to admin_recipes_path, notice: '記事を削除しました。'
	end
end
