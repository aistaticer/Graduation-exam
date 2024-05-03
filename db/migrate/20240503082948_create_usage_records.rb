class CreateUsageRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_records, id: :bigint do |t|
      t.bigint "user_id"
      t.timestamps
    end
  end
end
