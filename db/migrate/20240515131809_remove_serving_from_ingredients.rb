class RemoveServingFromIngredients < ActiveRecord::Migration[7.0]
  def change
    remove_column :ingredients, :serving, :integer
  end
end
