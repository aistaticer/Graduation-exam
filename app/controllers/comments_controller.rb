class CommentsController < ApplicationController
	before_action :set_recipe

  def create
    @comment = @recipe.comments.build(comment_params)
    @comment.user = current_user

    decorated_recipe = RecipeDecorator.new(@recipe)
    
    parent_comment_place_value = params[:comment][:parent_comment_place]
    child_comment_place_value = params[:comment][:child_comment_place]

    if @comment.save
      flash[:notice] = "コメントが正常に作成されました。"
      respond_to do |format|
        format.html { redirect_to @recipe }
        format.json { render json: @comment }
        format.turbo_stream do
          turbo_streams = []

          if(parent_comment_place_value.present?)
            turbo_streams << turbo_stream.after(parent_comment_place_value, partial: "shared/comment/comment_body", locals: { recipe: @recipe, comment: @comment, decorated_recipe: decorated_recipe })
          end
          
          if(child_comment_place_value.present?)
            @comment_with_reply_ids = []
            @parent_comment = Comment.find(params[:comment][:parent_id])
            turbo_streams << turbo_stream.update(child_comment_place_value, partial: "shared/comment/comment_mass", locals: { recipe: @recipe, comment: @parent_comment, parent_comments: @parent_comments, decorated_recipe: decorated_recipe })
          end

          turbo_streams << turbo_stream.update("error", partial: "shared/flash_error", locals: { notice: flash[:notice] })

          render turbo_stream: turbo_streams

        end
      end
    end
	end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to recipe_path(@recipe), notice: 'コメントを削除しました。'
  end

	private
	def set_recipe
		@recipe = Recipe.find(params[:recipe_id])
	end

	def comment_params
		params.require(:comment).permit(:body, :parent_id, :reply_to_id)
	end
end
