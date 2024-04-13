class Recipe < ApplicationRecord
	has_many :steps, dependent: :destroy
	has_one_attached :thumbnail, dependent: :destroy
end
