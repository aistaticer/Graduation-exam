class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :bigint do |t|
      t.text "body"
      t.bigint "recipe_id"
      t.bigint "user_id"
      t.integer "parent_id"
      t.integer "reply_to_id"
      t.timestamps
    end
  end
end
