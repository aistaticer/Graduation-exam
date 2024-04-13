class AddColumnsToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :name, :string
    add_column :recipes, :user_id, :integer
    add_column :recipes, :bio, :text
    add_column :recipes, :thumbnail, :string
    add_column :recipes, :copy_permission, :boolean
    add_column :recipes, :copy_recipe_id, :bigint
    add_column :recipes, :highlight, :text
  end
end
