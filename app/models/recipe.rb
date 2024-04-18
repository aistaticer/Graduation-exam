class Recipe < ApplicationRecord
	has_many :steps, dependent: :destroy
	has_one_attached :thumbnail, dependent: :destroy
  accepts_nested_attributes_for :steps

	has_many :stamp_middles
	attr_accessor :likes_count
	attr_accessor :user_like
	attr_accessor :current_user_like_id


end
