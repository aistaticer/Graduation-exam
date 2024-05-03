class UsageRecord < ActiveRecord::Migration[7.0]
  def change
    add_column :usage_records, :last_used_on, :date
  end
end
