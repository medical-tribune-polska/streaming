# This migration comes from streaming (originally 20190307083759)
class CreateStreamAccesses < ActiveRecord::Migration
  def change
    create_table :stream_accesses do |t|
      t.string :slug
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile_phone
      t.references :stream_event, index: true, foreign_key: true
      t.string :iframe_link, null: false
      t.string :stream_user, null: false
      t.string :city
      t.string :voivodeship
      t.integer :perdix_id
      t.integer :paid_status, default: 0
      t.integer :watched_minutes
      t.float :test_result
      t.datetime :removed_at

      t.timestamps null: false
    end
    add_index :stream_accesses, :slug
    add_index :stream_accesses, :email
    add_index :stream_accesses, :perdix_id
    add_index :stream_accesses, :paid_status
    add_index :stream_accesses, :removed_at
  end
end
