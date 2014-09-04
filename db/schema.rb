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

ActiveRecord::Schema.define(version: 20140904210101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "overview"
    t.text     "options"
  end

  add_index "accounts", ["company_name"], name: "index_accounts_on_company_name", unique: true, using: :btree

  create_table "budgets", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount_allocated", precision: 8, scale: 2
    t.decimal  "amount_used",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discussions", force: true do |t|
    t.text     "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "my_courses", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",           limit: 20
    t.string   "assigned_by",      limit: 20
    t.datetime "completion_date"
    t.decimal  "percent_complete"
    t.decimal  "my_rating"
  end

  create_table "pending_users", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "email"
    t.string "encrypted_password"
  end

  create_table "playlist_items", force: true do |t|
    t.integer  "playlist_id", null: false
    t.integer  "product_id",  null: false
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlist_items", ["playlist_id", "product_id"], name: "index_playlist_items_on_playlist_id_and_product_id", using: :btree
  add_index "playlist_items", ["product_id", "playlist_id"], name: "index_playlist_items_on_product_id_and_playlist_id", using: :btree

  create_table "playlists", force: true do |t|
    t.string   "title"
    t.boolean  "mandatory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "account_id"
  end

  create_table "playlists_users", id: false, force: true do |t|
    t.integer "user_id",     null: false
    t.integer "playlist_id", null: false
  end

  add_index "playlists_users", ["playlist_id", "user_id"], name: "index_playlists_users_on_playlist_id_and_user_id", using: :btree
  add_index "playlists_users", ["user_id", "playlist_id"], name: "index_playlists_users_on_user_id_and_playlist_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
    t.string   "authors"
    t.string   "origin"
    t.decimal  "price",                   precision: 8, scale: 2
    t.text     "keywords"
    t.string   "school"
    t.text     "description"
    t.string   "media_type",   limit: 10
    t.decimal  "duration",                precision: 8, scale: 2
    t.decimal  "avg_rating"
    t.boolean  "manual_entry",                                    default: true
    t.boolean  "price_free",                                      default: false
    t.integer  "account_id"
  end

  add_index "products", ["account_id"], name: "index_products_on_account_id", using: :btree
  add_index "products", ["name"], name: "index_products_on_name", using: :btree

  create_table "profiles", force: true do |t|
    t.string   "title"
    t.string   "employee_identifier"
    t.binary   "photo"
    t.integer  "user_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "photo_thumb"
  end

  create_table "roles", force: true do |t|
    t.string   "name",       limit: 5
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.text     "preferences"
    t.integer  "user_id"
    t.boolean  "processed",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "account_id"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "reset_required"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
  end

end
