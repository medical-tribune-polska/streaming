class CreateStreamAnalytics < ActiveRecord::Migration
  def change
    create_table :stream_analytics do |t|
      t.references :stream_event, index: true, foreign_key: true
      t.references :stream_access, index: true, foreign_key: true
      t.datetime :watched_at
    end
    add_index :stream_analytics, :watched_at
  end
end
