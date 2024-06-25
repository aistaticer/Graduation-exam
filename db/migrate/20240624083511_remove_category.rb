class RemoveCategory < ActiveRecord::Migration[7.0]
  def change
    drop_table :categories
    drop_table :categories_recipes
  end
end
