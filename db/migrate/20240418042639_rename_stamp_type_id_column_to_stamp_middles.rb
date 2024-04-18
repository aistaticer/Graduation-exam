class RenameStampTypeIdColumnToStampMiddles < ActiveRecord::Migration[7.0]
  def change
    rename_column :stamp_middles, :stamp_type_id, :stamps_type_id
  end
end
