class StampMiddle < ApplicationRecord
	belongs_to :recipe
  belongs_to :user
  validates :user_id, uniqueness: { scope: [:recipe_id, :stamps_type_id] }
  belongs_to :stamps_type

  def self.count_like_recipe(recipes)
    #　ハッシュでレシピのidごとにいいねの数を取得している（例　{7=>1, 8=>1}）
    likes_count = Recipe.joins(:stamp_middles)
      .where(stamp_middles: { stamps_type_id: StampMiddle.like_id_find() })
      .group(:id)
      .count

		recipes.each do |recipe|
			recipe.likes_count = likes_count[recipe.id] || 0
		end
  end

  def self.liked_by_user?(recipes, user_id)
    # レシピIDとスタンプミドルIDのペアを取得
    liked_recipes_and_stamps = Recipe.joins(:stamp_middles)
                                      .where(stamp_middles: { stamps_type_id: StampMiddle.like_id_find(), user_id: user_id })
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

  def self.like_id_find()
    like_type = StampsType.find_by(name: 'Like')
    return like_type.id
  end

  def self.count_stamp_recipe(recipes,delicious_type,like_type)

    #　ハッシュでレシピのidごとにいいねの数を取得している（例　{7=>1, 8=>1}）
    if like_type.present?
      likes_count = Recipe.joins(:stamp_middles)
        .where(stamp_middles: { stamps_type_id: like_type.id})
        .group(:id)
        .count
    end

    if delicious_type.present?
      delicious_count = Recipe.joins(:stamp_middles)
        .where(stamp_middles: { stamps_type_id: delicious_type.id })
        .group(:id)
        .count
    end

    likes_count ||= {}
    delicious_count ||= {}

    recipes.each do |recipe|
      recipe.likes_count = likes_count[recipe.id] || 0
      recipe.delicious_count = delicious_count[recipe.id] || 0
    end
  end

  def self.stamped_by_user?(recipes, user_id, delicious_type, like_type)
    # レシピIDとスタンプミドルIDのペアを取得
    liked_recipes_and_stamps = Recipe.joins(:stamp_middles)
                                      .where(stamp_middles: { stamps_type_id: like_type.id, user_id: user_id })
                                      .pluck('recipes.id', 'stamp_middles.id')
                                  
    delicious_recipes_and_stamps = Recipe.joins(:stamp_middles)
                                      .where(stamp_middles: { stamps_type_id: delicious_type, user_id: user_id })
                                      .pluck('recipes.id', 'stamp_middles.id')


    # 各レシピに対して、liked_recipes_and_stampsから対応するいいねIDを設定
    recipes.each do |recipe|
      # 現在のレシピに対するスタンプのIDを探す
      current_user_like_id_for_recipe = liked_recipes_and_stamps.detect { |r_id, s_id| r_id == recipe.id }&.second
      current_user_delicious_id_for_recipe = delicious_recipes_and_stamps.detect { |r_id, s_id| r_id == recipe.id }&.second
      
      # レシピがスタンプされているかどうかを設定 recipe_introduceのスタンプの分岐で使用.
      recipe.user_like = !current_user_like_id_for_recipe.nil?
      recipe.user_delicious = !current_user_delicious_id_for_recipe.nil?

      # 対応するスタンプIDを設定
      recipe.current_user_like_id = current_user_like_id_for_recipe
      recipe.current_user_delicious_id = current_user_delicious_id_for_recipe
    end
  end
end
