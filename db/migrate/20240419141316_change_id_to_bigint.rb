class ChangeIdToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :recipes, :id, :bigint
  end
end
