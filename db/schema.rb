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

ActiveRecord::Schema[8.1].define(version: 2026_03_09_130415) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "formation_modules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "formation_modules_plans", id: false, force: :cascade do |t|
    t.integer "formation_module_id", null: false
    t.integer "formation_plan_id", null: false
    t.index ["formation_module_id"], name: "index_formation_modules_plans_on_formation_module_id"
    t.index ["formation_plan_id"], name: "index_formation_modules_plans_on_formation_plan_id"
  end

  create_table "formation_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.date "admission_date"
    t.string "avs_number"
    t.date "birthdate"
    t.string "city"
    t.date "contract_end"
    t.date "contract_start"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.date "end_date"
    t.string "firstname"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "lastname"
    t.string "phone_number"
    t.string "postal_code"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "school_class_id"
    t.integer "sign_in_count", default: 0, null: false
    t.string "street"
    t.string "street_number"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["avs_number"], name: "index_people_on_avs_number", unique: true
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
    t.index ["school_class_id"], name: "index_people_on_school_class_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formation_plan_id"
    t.string "name", null: false
    t.integer "responsable_id", null: false
    t.datetime "updated_at", null: false
    t.index ["formation_plan_id"], name: "index_school_classes_on_formation_plan_id"
    t.index ["name"], name: "index_school_classes_on_name", unique: true
    t.index ["responsable_id"], name: "index_school_classes_on_responsable_id"
  end

  create_table "unities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formation_module_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["formation_module_id"], name: "index_unities_on_formation_module_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "people", "school_classes"
  add_foreign_key "school_classes", "formation_plans"
  add_foreign_key "school_classes", "people", column: "responsable_id"
  add_foreign_key "unities", "formation_modules"
end
