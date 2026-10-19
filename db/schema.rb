# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2016_05_11_021218) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer "ship_id", null: false
    t.string "event_name", null: false
    t.json "event_attributes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "network_id"
  end

  create_table "ships", force: :cascade do |t|
    t.text "name", null: false
    t.text "image", null: false
    t.inet "source"
    t.integer "shield", null: false
    t.integer "energy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "container_id"
    t.integer "port"
    t.integer "sector_id"
    t.string "token"
    t.datetime "last_charged_at"
    t.index ["name"], name: "index_ships_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.integer "github_uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
