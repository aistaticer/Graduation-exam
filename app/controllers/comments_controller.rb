class CommentsController < ApplicationController
	before_action :set_recipe

	def create
		@comment = @recipe.comments.build(comment_params)
		@comment.user = current_user
		if @comment.save
    end
	end

	private
	def set_recipe
		@recipe = Recipe.find(params[:recipe_id])
	end

	def comment_params
		params.require(:comment).permit(:body, :parent_id, :reply_to_id)
	end
end
