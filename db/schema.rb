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

ActiveRecord::Schema.define(version: 20180508045551) do

  create_table "authority_status", force: :cascade do |t|
    t.datetime "dt_stamp"
    t.integer "test_count"
    t.integer "failure_count"
  end

  create_table "authority_status_failure", force: :cascade do |t|
    t.integer "authority_status_id"
    t.string "status"
    t.string "status_label"
    t.string "authority_name"
    t.string "subauthority_name"
    t.string "service"
    t.string "action"
    t.string "url"
    t.string "err_message"
    t.index ["authority_status_id"], name: "index_authority_status_failure_on_authority_status_id"
  end

end
