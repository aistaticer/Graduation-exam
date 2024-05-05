class AddColumnRecipes < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :genre, foreign_key: true
    add_reference :recipes, :menu, foreign_key: true
  end
end
