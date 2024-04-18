class StampMiddlesController < ApplicationController
	def create
    @recipe = Recipe.find(params[:recipe_id])
    # いいねの種類のIDを見つける（ここでは、nameが'Like'のものとする）
    like_type = StampsType.find_by(name: 'Like')

    # 新しいいいねを作成
    @like = StampMiddle.new(recipe_id: @recipe.id, user_id: current_user.id, stamps_type_id: like_type.id)
    if @like.save
			StampMiddle.count_like_recipe([@recipe])
			respond_to do |format|

				format.turbo_stream do
					render turbo_stream: [
						turbo_stream.replace("unliked_button_#{@recipe.id}", partial: 'shared/stamps/like_delete', locals: { recipe: @recipe, stamp_middle: @like.id}),
						turbo_stream.replace("like_count_#{@recipe.id}", partial: 'shared/stamps/like_count', locals: { recipe: @recipe})
					]
				end
				format.html { redirect_to recipes_path }
			end

			Rails.logger.debug("成功");
    else
			Rails.logger.debug("失敗");
			#Rails.logger.debug(@like.errors.full_messages)
    end
	end

	def destroy
		@stamp = StampMiddle.find(params[:id])
		@recipe = Recipe.find(params[:recipe_id])

		if @stamp.destroy
			StampMiddle.count_like_recipe([@recipe])
			Rails.logger.debug("like_count_#{@recipe.id}");
			respond_to do |format|

				format.turbo_stream do
					render turbo_stream: [
						turbo_stream.replace("like_count_#{@recipe.id}", partial: 'shared/stamps/like_count', locals: { recipe: @recipe}),
						turbo_stream.replace("liked_button_#{@recipe.id}", partial: 'shared/stamps/like_create', locals: { recipe: @recipe })
					]
				end
				format.html { redirect_to recipes_path }
			end
		else
			# 失敗した場合の処理（必要に応じて）
		end
	end

	private


end
