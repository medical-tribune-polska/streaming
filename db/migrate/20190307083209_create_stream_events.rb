class CreateStreamEvents < ActiveRecord::Migration
  def change
    create_table :stream_events do |t|
      t.string :name, null: false
      t.datetime :starting
      t.datetime :finishing
      t.string :place
      t.string :education_points
      t.text :agenda
      t.string :congress_image_file_name
      t.string :congress_image_content_type
      t.integer :congress_image_file_size
      t.datetime :congress_image_updated_at
      t.string :congress_logo_file_name
      t.string :congress_logo_content_type
      t.integer :congress_logo_file_size
      t.datetime :congress_logo_updated_at
      t.string :info_color
      t.string :brochure_file_name
      t.string :brochure_content_type
      t.integer :brochure_file_size
      t.datetime :brochure_updated_at

      t.timestamps null: false
    end
  end
end
