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

ActiveRecord::Schema.define(version: 20150119212829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "delivery_addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "full_name",  limit: 255
    t.string   "address",    limit: 255
    t.string   "province",   limit: 255
    t.string   "city",       limit: 255
    t.string   "postal",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finishing_options", id: false, force: :cascade do |t|
    t.integer "large_format_id"
    t.integer "large_format_finishing_id"
  end

  add_index "finishing_options", ["large_format_finishing_id"], name: "index_finishing_options_on_large_format_finishing_id", using: :btree
  add_index "finishing_options", ["large_format_id"], name: "index_finishing_options_on_large_format_id", using: :btree

  create_table "large_format_finishings", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "large_format_thicknesses", force: :cascade do |t|
    t.integer "large_format_id"
    t.integer "thickness"
    t.string  "unit",            limit: 255
  end

  create_table "large_format_tiers", force: :cascade do |t|
    t.integer "large_format_thickness_id"
    t.string  "level",                     limit: 255
    t.integer "min_sqft"
    t.integer "max_sqft"
    t.decimal "price"
  end

  create_table "large_formats", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.text     "description"
    t.integer  "sides"
    t.string   "display_image_file_name",    limit: 255
    t.string   "display_image_content_type", limit: 255
    t.integer  "display_image_file_size"
    t.datetime "display_image_updated_at"
    t.string   "status",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_two_side"
  end

  create_table "metal_sign_sizes", force: :cascade do |t|
    t.integer "metal_sign_id"
    t.integer "width"
    t.integer "height"
    t.string  "unit",          limit: 255
    t.decimal "price"
  end

  create_table "metal_signs", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.text     "description"
    t.string   "display_image_file_name",    limit: 255
    t.string   "display_image_content_type", limit: 255
    t.integer  "display_image_file_size"
    t.datetime "display_image_updated_at"
    t.string   "status",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_transactions", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "action",        limit: 255
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization", limit: 255
    t.string   "message",       limit: 255
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ordered_large_format_details", force: :cascade do |t|
    t.integer "length"
    t.integer "width"
    t.integer "side"
    t.integer "thickness_id"
    t.string  "finishing",         limit: 255
    t.integer "grommets_quantity"
    t.string  "unit",              limit: 255
  end

  create_table "ordered_metal_sign_details", force: :cascade do |t|
    t.integer "size_id"
  end

  create_table "ordered_products", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "quantity"
    t.decimal  "unit_price"
    t.decimal  "price"
    t.string   "print_pdf_file_name",      limit: 255
    t.string   "print_pdf_content_type",   limit: 255
    t.integer  "print_pdf_file_size"
    t.datetime "print_pdf_updated_at"
    t.string   "print_pdf_2_file_name",    limit: 255
    t.string   "print_pdf_2_content_type", limit: 255
    t.integer  "print_pdf_2_file_size"
    t.datetime "print_pdf_2_updated_at"
    t.string   "product_type",             limit: 255
    t.integer  "product_detail_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "order_id",         limit: 255
    t.integer  "delivery_id"
    t.text     "delivery_address"
    t.decimal  "sub_total"
    t.string   "status",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "delivery_method",  limit: 255
    t.string   "express_payer_id", limit: 255
    t.string   "express_token",    limit: 255
    t.string   "ip_address",       limit: 255
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",                       limit: 255
    t.text     "excerpt"
    t.text     "content"
    t.string   "author",                      limit: 255
    t.string   "category",                    limit: 255
    t.string   "featured_image_file_name",    limit: 255
    t.string   "featured_image_content_type", limit: 255
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slider_images", force: :cascade do |t|
    t.string   "slide_image_file_name",    limit: 255
    t.string   "slide_image_content_type", limit: 255
    t.integer  "slide_image_file_size"
    t.datetime "slide_image_updated_at"
    t.string   "product_type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "status",                 limit: 255
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "company_name",           limit: 255
    t.string   "company_address",        limit: 255
    t.string   "company_province",       limit: 255
    t.string   "company_city",           limit: 255
    t.string   "company_postal",         limit: 255
    t.string   "company_hst",            limit: 255
    t.string   "company_phone",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["status"], name: "index_users_on_status", using: :btree

end
