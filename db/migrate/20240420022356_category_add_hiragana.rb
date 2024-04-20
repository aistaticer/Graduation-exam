class CategoryAddHiragana < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :hiragana, :string
  end
end
