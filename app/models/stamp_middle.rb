class StampMiddle < ApplicationRecord
	belongs_to :recipe
  belongs_to :user
  belongs_to :stamps_type

  def self.count_like_recipe(recipes)
    #　ハッシュでレシピのidごとにいいねの数を取得している（例　{7=>1, 8=>1}）
    likes_count = Recipe.joins(:stamp_middles)
      .where(stamp_middles: { stamps_type_id: 1 })
      .group(:id)
      .count

		recipes.each do |recipe|
			recipe.likes_count = likes_count[recipe.id] || 0
		end
  end

  def self.liked_by_user?(recipes, user_id)
    # レシピIDとスタンプミドルIDのペアを取得
    liked_recipes_and_stamps = Recipe.joins(:stamp_middles)
                                      .where(stamp_middles: { stamps_type_id: 1, user_id: user_id })
                                      .pluck('recipes.id', 'stamp_middles.id')
    
    # 各レシピに対して、liked_recipes_and_stampsから対応するいいねIDを設定
    recipes.each do |recipe|
      # 現在のレシピに対するいいねのIDを探す
      current_user_like_id_for_recipe = liked_recipes_and_stamps.detect { |r_id, s_id| r_id == recipe.id }&.second
      
      # レシピがいいねされているかどうかを設定
      recipe.user_like = !current_user_like_id_for_recipe.nil?
      # 対応するいいねIDを設定
      recipe.current_user_like_id = current_user_like_id_for_recipe
    end
  end
end
