class CopiedRecipe < ApplicationRecord
  belongs_to :recipe, dependent: :destroy
end
