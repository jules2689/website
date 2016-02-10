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

ActiveRecord::Schema.define(version: 20160210045351) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "interests", force: :cascade do |t|
    t.string   "interest_type"
    t.string   "treatment"
    t.string   "embed_url"
    t.string   "url"
    t.string   "provider"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url", limit: 500
    t.boolean  "is_private", default: false
  end

  create_table "post_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count"
  end

  add_index "post_categories", ["title"], name: "index_post_categories_on_title", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_date", default: '2016-02-09 05:09:51'
    t.string   "dominant_header_colour"
    t.string   "published_key"
    t.string   "header_image_url", limit: 500
    t.integer  "post_category_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context", limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", %w(tag_id taggable_id taggable_type context tagger_id tagger_type), name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", %w(taggable_id taggable_type context), name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree
end
