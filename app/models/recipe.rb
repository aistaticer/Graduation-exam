class Recipe < ApplicationRecord

  belongs_to :user, optional: true

  has_many :steps, dependent: :destroy
  has_one_attached :thumbnail, dependent: :destroy
  accepts_nested_attributes_for :steps

  has_one :copied_recipe, dependent: :destroy
  accepts_nested_attributes_for :copied_recipe

  has_many :stamp_middles
  
  attr_accessor :likes_count
  attr_accessor :user_like
  attr_accessor :current_user_like_id
  
  attr_accessor :delicious_count
  attr_accessor :user_delicious
  attr_accessor :current_user_delicious_id

  has_many :categories_recipes
  has_many :categories, through: :categories_recipes

  has_many :comments, dependent: :destroy

  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients

  belongs_to :genre
  belongs_to :menu

  validates :bio, :serving, :user_id, presence: true
  validates :name, length: { maximum: 25, message: "レシピ名は25文字以内で入力してください" }, presence: true
  validates :bio, length: { maximum: 255, message: "レシピ紹介文は255文字以内で入力してください" }, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["bio", "copy_permission", "copy_recipe_id", "created_at", "highlight", "id", "name", "thumbnail", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["genre", "menu"]
  end
end
