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

ActiveRecord::Schema.define(version: 20150919011134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ships", force: :cascade do |t|
    t.inet     "source",         null: false
    t.integer  "maximum_shield", null: false
    t.integer  "recharge_rate",  null: false
    t.integer  "energy_reserve", null: false
    t.integer  "fire_rate",      null: false
    t.integer  "weapon_damage",  null: false
    t.integer  "accuracy",       null: false
    t.integer  "stealth",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
