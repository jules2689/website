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

ActiveRecord::Schema.define(version: 20151215040548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "front_page_widgets", force: true do |t|
    t.string   "title"
    t.string   "subtext"
    t.string   "url"
    t.string   "image_uid"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_url",  limit: 500
  end

  create_table "images", force: true do |t|
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "title"
    t.string   "width"
    t.string   "dominant_colour"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.string   "path",            limit: 500
    t.string   "old_url",         limit: 500
  end

  create_table "interests", force: true do |t|
    t.string   "interest_type"
    t.string   "treatment"
    t.string   "embed_url"
    t.string   "url"
    t.string   "provider"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url",     limit: 500
    t.boolean  "is_private",                default: false
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_date",                     default: '2015-01-31 06:19:36'
    t.string   "header_image_uid"
    t.string   "header_image_name"
    t.string   "dominant_header_colour"
    t.string   "published_key"
    t.string   "header_image_url",       limit: 500
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
