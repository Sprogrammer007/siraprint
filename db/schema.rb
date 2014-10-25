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

ActiveRecord::Schema.define(version: 20141024215248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "delivery_addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "full_name"
    t.string   "address"
    t.string   "province"
    t.string   "city"
    t.string   "postal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "large_print_materials", force: true do |t|
    t.integer  "large_print_id"
    t.string   "material_name"
    t.string   "material_image_file_name"
    t.string   "material_image_content_type"
    t.integer  "material_image_file_size"
    t.datetime "material_image_updated_at"
  end

  create_table "large_print_tiers", force: true do |t|
    t.integer "material_thickness_id"
    t.string  "level"
    t.integer "min_sqft"
    t.integer "max_sqft"
    t.decimal "price"
  end

  create_table "large_prints", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sides"
    t.string   "display_image_file_name"
    t.string   "display_image_content_type"
    t.integer  "display_image_file_size"
    t.datetime "display_image_updated_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "material_thicknesses", force: true do |t|
    t.integer "large_print_material_id"
    t.integer "thickness"
    t.string  "unit"
  end

  create_table "metal_signs", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "display_image_file_name"
    t.string   "display_image_content_type"
    t.integer  "display_image_file_size"
    t.datetime "display_image_updated_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ordered_large_print_details", force: true do |t|
    t.integer "length"
    t.integer "width"
    t.integer "material_id"
    t.integer "thickness_id"
    t.string  "unit"
  end

  create_table "ordered_products", force: true do |t|
    t.integer  "order_id"
    t.integer  "quantity"
    t.decimal  "unit_price"
    t.decimal  "price"
    t.string   "print_pdf_file_name"
    t.string   "print_pdf_content_type"
    t.integer  "print_pdf_file_size"
    t.datetime "print_pdf_updated_at"
    t.string   "product_type"
    t.integer  "product_detail_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "order_id"
    t.string   "delivery_method"
    t.decimal  "sub_total"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delivery_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                   default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "status"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "company_name"
    t.string   "company_address"
    t.string   "company_province"
    t.string   "company_city"
    t.string   "company_postal"
    t.string   "company_hst"
    t.string   "company_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["status"], name: "index_users_on_status", unique: true, using: :btree

end
