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

ActiveRecord::Schema[7.0].define(version: 2023_03_15_023234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "cif", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cif"], name: "index_merchants_on_cif", unique: true
    t.index ["email"], name: "index_merchants_on_email", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount", null: false
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "merchant_id", null: false
    t.bigint "shopper_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
    t.index ["shopper_id"], name: "index_orders_on_shopper_id"
  end

  create_table "shoppers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "nif", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_shoppers_on_email", unique: true
    t.index ["nif"], name: "index_shoppers_on_nif", unique: true
  end

  add_foreign_key "orders", "merchants"
  add_foreign_key "orders", "shoppers"
end
