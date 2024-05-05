class Ingredient < ApplicationRecord
	belongs_to :recipe
	validates :name, length: { maximum: 25, message: "材料名は25文字以内で入力してください" }, presence: true
	validates :quantity, length: { maximum: 25, message: "分量は25文字以内で入力してください" }, presence: true
	validates :serving, presence: true
end
