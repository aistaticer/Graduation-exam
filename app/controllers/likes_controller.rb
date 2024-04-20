class LikesController < ApplicationController
	def index
		recipe_ids = StampMiddle.where(user_id: current_user.id).pluck(:recipe_id)
		@liked_recipes = Recipe.where(id: recipe_ids).with_attached_thumbnail.page(params[:page]).per(10)
		StampMiddle.liked_by_user?(@liked_recipes,current_user.id)
		StampMiddle.count_like_recipe(@liked_recipes)
	end
end