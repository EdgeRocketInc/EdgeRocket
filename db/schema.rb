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

ActiveRecord::Schema.define(version: 20140422175248) do

  create_table "accounts", force: true do |t|
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "budget_management"
  end

  add_index "accounts", ["company_name"], name: "index_accounts_on_company_name", unique: true

  create_table "budgets", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount_allocated", precision: 8, scale: 2
    t.decimal  "amount_used",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "playlists", force: true do |t|
    t.string   "title"
    t.boolean  "mandatory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "account_id"
  end

  create_table "playlists_products", id: false, force: true do |t|
    t.integer "playlist_id", null: false
    t.integer "product_id",  null: false
  end

  add_index "playlists_products", ["playlist_id", "product_id"], name: "index_playlists_products_on_playlist_id_and_product_id"
  add_index "playlists_products", ["product_id", "playlist_id"], name: "index_playlists_products_on_product_id_and_playlist_id"

  create_table "playlists_users", id: false, force: true do |t|
    t.integer "user_id",     null: false
    t.integer "playlist_id", null: false
  end

  add_index "playlists_users", ["playlist_id", "user_id"], name: "index_playlists_users_on_playlist_id_and_user_id"
  add_index "playlists_users", ["user_id", "playlist_id"], name: "index_playlists_users_on_user_id_and_playlist_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
    t.string   "authors"
    t.string   "origin"
    t.decimal  "price",      precision: 8, scale: 2
    t.text     "keywords"
    t.string   "school"
  end

  create_table "roles", force: true do |t|
    t.string   "name",       limit: 5
    t.integer  "user_id"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
  end

end
