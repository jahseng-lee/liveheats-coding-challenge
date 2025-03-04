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

ActiveRecord::Schema[8.0].define(version: 2025_02_18_014131) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "participants", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "race_id"
    t.integer "lane"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "placing"
    t.index ["race_id"], name: "index_participants_on_race_id"
    t.index ["student_id"], name: "index_participants_on_student_id"
  end

  create_table "races", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["name"], name: "index_races_on_name", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
