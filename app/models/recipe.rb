class Recipe < ApplicationRecord
  has_many :steps, dependent: :destroy
  has_one_attached :thumbnail, dependent: :destroy
  accepts_nested_attributes_for :steps

  belongs_to :copied_recipe, dependent: :destroy
  accepts_nested_attributes_for :copied_recipe

  has_many :stamp_middles
  attr_accessor :likes_count
  attr_accessor :user_like
  attr_accessor :current_user_like_id

  has_many :categories_recipes
  has_many :categories, through: :categories_recipes

  has_many :comments, dependent: :destroy

  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "copy_permission", "copy_recipe_id", "created_at", "highlight", "id", "name", "thumbnail", "updated_at", "user_id"]
  end
end
