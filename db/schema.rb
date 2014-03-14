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

ActiveRecord::Schema.define(version: 20140314141500) do

  create_table "playlists", force: true do |t|
    t.string   "title"
    t.boolean  "mandatory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists_products", id: false, force: true do |t|
    t.integer "playlist_id", null: false
    t.integer "product_id",  null: false
  end

  add_index "playlists_products", ["playlist_id", "product_id"], name: "index_playlists_products_on_playlist_id_and_product_id"
  add_index "playlists_products", ["product_id", "playlist_id"], name: "index_playlists_products_on_product_id_and_playlist_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
  end

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
