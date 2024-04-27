class AddoriginalRecipeIdCopiedRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :copied_recipes, :original_recipe, :bigint
    add_column :copied_recipes, :before_recipe, :bigint
  end
end
