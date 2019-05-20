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

ActiveRecord::Schema.define(version: 2019_05_20_141203) do

  create_table "countries", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_drugs", force: :cascade do |t|
    t.string "mnn"
    t.string "quantity"
    t.string "price"
    t.string "cost"
    t.integer "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_customer_drugs_on_request_id"
  end

  create_table "dosages", force: :cascade do |t|
    t.string "form"
    t.string "value"
    t.string "unit"
    t.integer "customer_drug_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_drug_id"], name: "index_dosages_on_customer_drug_id"
  end

  create_table "drugs", force: :cascade do |t|
    t.string "name"
    t.string "mnn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dosage_form"
    t.string "unit"
    t.string "pack"
    t.integer "country_id"
    t.index ["country_id"], name: "index_drugs_on_country_id"
  end

  create_table "request_drugs", force: :cascade do |t|
    t.integer "request_id"
    t.integer "drug_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.string "unit"
    t.index ["drug_id"], name: "index_request_drugs_on_drug_id"
    t.index ["request_id"], name: "index_request_drugs_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "auction_number"
    t.string "customer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.string "etp"
    t.string "purchase_info"
    t.string "max_price"
    t.string "delivery_place"
    t.string "delivery_time"
    t.string "exp_date"
  end

end
