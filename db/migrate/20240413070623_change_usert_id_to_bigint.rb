class ChangeUsertIdToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :id, :bigint
    change_column :recipes, :user_id, :bigint
  end
end
