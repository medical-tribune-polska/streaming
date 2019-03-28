class AddImportedFromCsvToStreamAccesses < ActiveRecord::Migration
  def change
    add_column :stream_accesses, :imported_from_csv, :boolean, default: false
    add_index :stream_accesses, :imported_from_csv
  end
end
