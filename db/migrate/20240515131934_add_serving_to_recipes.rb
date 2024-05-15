class AddServingToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :serving, :integer
  end
end
