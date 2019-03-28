# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190319085207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stream_accesses", force: :cascade do |t|
    t.string   "slug"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "mobile_phone"
    t.integer  "stream_event_id"
    t.string   "iframe_link",                       null: false
    t.string   "stream_user",                       null: false
    t.string   "city"
    t.string   "voivodeship"
    t.integer  "perdix_id"
    t.integer  "paid_status",       default: 0
    t.integer  "watched_minutes"
    t.float    "test_result"
    t.datetime "removed_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "imported_from_csv", default: false
    t.boolean  "working_in_mt",     default: false
    t.string   "notes",             default: [],                 array: true
  end

  add_index "stream_accesses", ["email"], name: "index_stream_accesses_on_email", using: :btree
  add_index "stream_accesses", ["imported_from_csv"], name: "index_stream_accesses_on_imported_from_csv", using: :btree
  add_index "stream_accesses", ["paid_status"], name: "index_stream_accesses_on_paid_status", using: :btree
  add_index "stream_accesses", ["perdix_id"], name: "index_stream_accesses_on_perdix_id", using: :btree
  add_index "stream_accesses", ["removed_at"], name: "index_stream_accesses_on_removed_at", using: :btree
  add_index "stream_accesses", ["slug"], name: "index_stream_accesses_on_slug", using: :btree
  add_index "stream_accesses", ["stream_event_id"], name: "index_stream_accesses_on_stream_event_id", using: :btree

  create_table "stream_analytics", force: :cascade do |t|
    t.integer  "stream_event_id"
    t.integer  "stream_access_id"
    t.datetime "watched_at"
  end

  add_index "stream_analytics", ["stream_access_id"], name: "index_stream_analytics_on_stream_access_id", using: :btree
  add_index "stream_analytics", ["stream_event_id"], name: "index_stream_analytics_on_stream_event_id", using: :btree
  add_index "stream_analytics", ["watched_at"], name: "index_stream_analytics_on_watched_at", using: :btree

  create_table "stream_events", force: :cascade do |t|
    t.string   "name",                                                                                                                                   null: false
    t.datetime "starting"
    t.datetime "finishing"
    t.text     "agenda"
    t.string   "congress_image_file_name"
    t.string   "congress_image_content_type"
    t.integer  "congress_image_file_size"
    t.datetime "congress_image_updated_at"
    t.string   "congress_logo_file_name"
    t.string   "congress_logo_content_type"
    t.integer  "congress_logo_file_size"
    t.datetime "congress_logo_updated_at"
    t.string   "brochure_file_name"
    t.string   "brochure_content_type"
    t.integer  "brochure_file_size"
    t.datetime "brochure_updated_at"
    t.datetime "created_at",                                                                                                                             null: false
    t.datetime "updated_at",                                                                                                                             null: false
    t.json     "breaks",                      default: {}
    t.json     "settings",                    default: {"education_points"=>nil, "place"=>nil, "info_color"=>nil, "show_popup"=>true, "popup_time"=>30}
  end

  add_foreign_key "stream_accesses", "stream_events"
  add_foreign_key "stream_analytics", "stream_accesses"
  add_foreign_key "stream_analytics", "stream_events"
end
