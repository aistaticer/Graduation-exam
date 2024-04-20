class Comment < ApplicationRecord
	belongs_to :recipe
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
  belongs_to :myreply, class_name: 'Comment', foreign_key: :reply_to_id, optional: true
end
