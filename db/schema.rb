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

ActiveRecord::Schema.define(version: 2021_10_10_100642) do

  create_table "vacation_requests", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "worker_id", null: false
    t.bigint "resolved_by_id"
    t.date "vacation_start_date"
    t.date "vacation_end_date"
    t.string "status", default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resolved_by_id"], name: "index_vacation_requests_on_resolved_by_id"
    t.index ["worker_id"], name: "index_vacation_requests_on_worker_id"
  end

  create_table "workers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.string "role"
    t.string "email"
    t.integer "vacation_days", default: 30
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "vacation_requests", "workers"
  add_foreign_key "vacation_requests", "workers", column: "resolved_by_id"
end
