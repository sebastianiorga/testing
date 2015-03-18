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

ActiveRecord::Schema.define(version: 20150318094551) do

  create_table "assets", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "description",   limit: 65535
    t.string   "tags",          limit: 255
    t.text     "extra",         limit: 65535
    t.integer  "user_id",       limit: 4
    t.string   "content_type",  limit: 255
    t.string   "upload_file",   limit: 255
    t.string   "data",          limit: 255
    t.boolean  "processed",     limit: 1,     default: false
    t.string   "aws_acl",       limit: 255,   default: "public-read"
    t.integer  "data_size",     limit: 4
    t.integer  "height",        limit: 4
    t.integer  "width",         limit: 4
    t.text     "versions_info", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["content_type"], name: "index_assets_on_content_type", using: :btree
  add_index "assets", ["user_id"], name: "index_assets_on_user_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer "asset_id",        limit: 4
    t.string  "attachable_type", limit: 255
    t.integer "attachable_id",   limit: 4
    t.integer "position",        limit: 4
    t.string  "box",             limit: 255
  end

  add_index "attachments", ["asset_id"], name: "index_attachments_on_asset_id", using: :btree
  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree
  add_index "attachments", ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "menu_items", force: :cascade do |t|
    t.integer "menu_id",       limit: 4
    t.integer "menuable_id",   limit: 4
    t.string  "menuable_type", limit: 255
    t.string  "title",         limit: 255
    t.string  "url",           limit: 255
    t.string  "special",       limit: 255
    t.string  "classes",       limit: 255
    t.boolean "new_window",    limit: 1,   default: false
    t.integer "roles_mask",    limit: 4
    t.integer "lft",           limit: 4
    t.integer "rgt",           limit: 4
  end

  add_index "menu_items", ["lft"], name: "index_menu_items_on_lft", using: :btree

  create_table "menus", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "meta_description", limit: 255
    t.boolean  "draft",            limit: 1,   default: false
    t.string   "layout",           limit: 255, default: "application"
    t.string   "template",         limit: 255
    t.string   "slug",             limit: 255
    t.integer  "roles_mask",       limit: 4,   default: 0
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "regionable_type", limit: 255
    t.integer  "regionable_id",   limit: 4
    t.string   "title",           limit: 255
    t.text     "content",         limit: 65535
    t.text     "snippets",        limit: 65535
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "regions", ["regionable_id"], name: "index_regions_on_regionable_id", using: :btree
  add_index "regions", ["regionable_type", "regionable_id"], name: "index_regions_on_regionable_type_and_regionable_id", using: :btree

end
