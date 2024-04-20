class Category < ApplicationRecord
	has_many :categories_recipes
  has_many :recipes, through: :categories_recipes

	def self.ransackable_attributes(auth_object = nil)
		["name","hiragana"]
	end

	def self.ransackable_associations(auth_object = nil)
    ["categories_recipes", "recipes"]
  end
end
