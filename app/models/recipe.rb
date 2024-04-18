class Recipe < ApplicationRecord
	has_many :steps, dependent: :destroy
	has_one_attached :thumbnail, dependent: :destroy
  accepts_nested_attributes_for :steps

	has_many :stamp_middles
end
