class Menu < ApplicationRecord
	has_many :recipes

	def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at"]
  end
end
