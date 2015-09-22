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

ActiveRecord::Schema.define(version: 20150922041252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer  "ship_id",          null: false
    t.integer  "event_name",       null: false
    t.json     "event_attributes"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.text     "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.cidr     "range",      null: false
  end

  create_table "ships", force: :cascade do |t|
    t.text     "name",            null: false
    t.text     "image",           null: false
    t.inet     "source"
    t.integer  "shield",          null: false
    t.integer  "energy",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "container_id"
    t.integer  "port"
    t.integer  "sector_id"
    t.string   "token"
    t.datetime "last_charged_at"
  end

  add_index "ships", ["name"], name: "index_ships_on_name", unique: true, using: :btree

end
