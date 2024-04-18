class CreateStampMiddles < ActiveRecord::Migration[7.0]
  def change
    create_table :stamp_middles do |t|
      t.bigint :recipe_id
      t.bigint :user_id
      t.integer :stamp_type_id
      t.timestamps
    end
  end
end
