class ChangeWatchedMinutesColumnsInStreamingAccesses < ActiveRecord::Migration
  def change
    remove_column :stream_accesses, :watched_minutes, :integer
    add_column :stream_accesses, :watched_minutes, :json, default: {}, null: false
  end
end
