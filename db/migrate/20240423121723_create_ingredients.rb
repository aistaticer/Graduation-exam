class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients, id: :bigint do |t|
      t.string :name
      t.integer :serving
      t.bigint :recipe_id
      t.timestamps
    end
  end
end
