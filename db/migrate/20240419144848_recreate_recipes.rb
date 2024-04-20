class RecreateRecipes < ActiveRecord::Migration[7.0]
  def change
    drop_table :recipes

    create_table :recipes, id: :bigint do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "name"
      t.integer "user_id"
      t.text "bio"
      t.string "thumbnail"
      t.boolean "copy_permission"
      t.integer "copy_recipe_id"
      t.text "highlight"
    end
  end
end