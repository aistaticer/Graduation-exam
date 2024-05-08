class CommentsController < ApplicationController
	before_action :set_recipe

	def index
		@parent_comments = @recipe.comments.includes(:user, replies: [:user, {myreply: :user}]).where(parent_id:nil).order(created_at: :desc)
		@replies = @recipe.comments.where.not(parent_id:nil)

		#avatar_url = rails_blob_path(current_user.avatar, only_path: true) if current_user.avatar.attached?

		decorated_recipe = RecipeDecorator.new(@recipe)
		avatar_url = rails_blob_url(decorated_recipe.resized_recipe_thumbnail(size: 100), only_path: true)if current_user.avatar.attached?

		user_data = [{"id": current_user.id, "name": current_user.name, "avatar_url": avatar_url}]

		#parent_comments_json = @parent_comments.as_json(include: { user: { methods: [:avatar_url], only: [:id, :name] } })
		parent_comments_json = @parent_comments.as_json(include: {
			user: { methods: [:avatar_url], only: [:id, :name] },
				replies: { 
					include: {
						user: { methods: [:avatar_url] , only: [:id, :name] },
						myreply: { include: { user: { methods: [:avatar_url] ,only: [:id, :name] } } }
				}
			}
		})
		replies_json = @replies.as_json(include: { user: { methods: [:avatar_url], only: [:id, :name] } })
		render json: { parent_comments: parent_comments_json ,replies: replies_json, current_user: user_data, comment_count: Comment.count}
	end

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
