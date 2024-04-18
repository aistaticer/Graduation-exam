class StampMiddle < ApplicationRecord
	belongs_to :recipe
  belongs_to :user
  belongs_to :stamps_type
end
