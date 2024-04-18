class StampMiddlesController < ApplicationController
	def create
    @recipe = Recipe.find(params[:recipe_id])
    # いいねの種類のIDを見つける（ここでは、nameが'Like'のものとする）
    like_type = StampsType.find_by(name: 'Like')
		Rails.logger.debug(@recipe.id);
		Rails.logger.debug(current_user.id);
		Rails.logger.debug(like_type);

    # 新しいいいねを作成
    @like = StampMiddle.new(recipe_id: @recipe.id, user_id: current_user.id, stamps_type_id: like_type.id)
    
    if @like.save
      # 成功した場合の処理（例: リダイレクトやフラッシュメッセージの設定）
			Rails.logger.debug("成功");
    else
			Rails.logger.debug("失敗");
			Rails.logger.debug(like_type.id);
			Rails.logger.debug(@like.errors.full_messages)
    end
	end

	def destroy
	end
end
