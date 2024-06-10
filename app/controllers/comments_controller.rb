class CommentsController < ApplicationController
	before_action :set_recipe

  def create
    @comment = @recipe.comments.build(comment_params)
    @comment.user = current_user

    @comments = @recipe.comments.includes(:user, replies: [:user, {myreply: :user}]).order(created_at: :desc)
    @parent_comments = @comments.where(parent_id:nil)
    decorated_recipe = RecipeDecorator.new(@recipe)
    
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @recipe }
        format.json { render json: @comment }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("comments", partial: "shared/comment/comment_each", locals: { recipe: @recipe, parent_comments: @parent_comments, decorated_recipe: decorated_recipe  })
        end
      end
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
