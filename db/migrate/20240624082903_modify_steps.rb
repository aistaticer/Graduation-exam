class ModifySteps < ActiveRecord::Migration[7.0]
  def change
    remove_column :steps, :integer
    change_column :steps, :number, :integer
  end
end
