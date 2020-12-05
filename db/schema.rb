# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_05_105904) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "street_name"
    t.string "city"
    t.string "county"
    t.text "details"
    t.string "postal_code"
    t.string "coordinates"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "addressable_id"
    t.string "addressable_type"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "signal_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "needs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "description"
    t.boolean "deleted", default: false
    t.integer "status", default: 0
    t.string "contact_phone_number"
    t.bigint "added_by_id", null: false
    t.bigint "chosen_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "status_updated_at"
    t.bigint "updated_by_id"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.bigint "address_id"
    t.integer "category"
    t.index ["added_by_id"], name: "index_needs_on_added_by_id"
    t.index ["address_id"], name: "index_needs_on_address_id"
    t.index ["chosen_by_id"], name: "index_needs_on_chosen_by_id"
    t.index ["updated_by_id"], name: "index_needs_on_updated_by_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "description"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "stars"
    t.text "comment"
    t.bigint "provided_by_id", null: false
    t.bigint "given_to_id", null: false
    t.bigint "need_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["given_to_id"], name: "index_reviews_on_given_to_id"
    t.index ["need_id"], name: "index_reviews_on_need_id"
    t.index ["provided_by_id"], name: "index_reviews_on_provided_by_id"
  end

  create_table "special_cases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "description"
    t.boolean "validated", default: false
    t.boolean "deleted", default: false
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_special_cases_on_user_id"
  end

  create_table "suggestions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "testimonials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "message"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_testimonials_on_user_id"
  end

  create_table "user_special_cases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "promotion_description"
    t.bigint "special_case_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["special_case_id"], name: "index_user_special_cases_on_special_case_id"
    t.index ["user_id"], name: "index_user_special_cases_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "cif"
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
  end

  add_foreign_key "devices", "users"
  add_foreign_key "needs", "users", column: "added_by_id"
  add_foreign_key "needs", "users", column: "chosen_by_id"
  add_foreign_key "needs", "users", column: "updated_by_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "reviews", "needs"
  add_foreign_key "reviews", "users", column: "given_to_id"
  add_foreign_key "reviews", "users", column: "provided_by_id"
  add_foreign_key "special_cases", "users"
  add_foreign_key "testimonials", "users"
  add_foreign_key "user_special_cases", "special_cases"
  add_foreign_key "user_special_cases", "users"
end
