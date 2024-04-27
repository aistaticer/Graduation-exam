class CreateCopiedRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :copied_recipes, id: :bigint do |t|
      t.bigint :recipe_id
      t.timestamps
    end
  end
end
