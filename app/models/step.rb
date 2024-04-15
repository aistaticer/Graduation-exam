class Step < ApplicationRecord
	belongs_to :recipe
	validates :process, presence: true, length: { maximum: 255 }
end
