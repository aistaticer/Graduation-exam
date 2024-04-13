class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.integer :recipe_id
      t.string :number
      t.string :integer
      t.text :process

      t.timestamps
    end
  end
end
