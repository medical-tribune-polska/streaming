class AddWorkingInMtToStreamAccesses < ActiveRecord::Migration
  def change
    add_column :stream_accesses, :working_in_mt, :boolean, default: false
    add_column :stream_accesses, :notes, :string, array: true, default: []
  end
end
