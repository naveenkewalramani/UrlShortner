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

ActiveRecord::Schema.define(version: 2019_02_01_045611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "short_domains", force: :cascade do |t|
    t.string "domain"
    t.string "prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_short_domains_on_domain"
  end

  create_table "urlreports", force: :cascade do |t|
    t.integer "count"
    t.string "date"
    t.index ["date"], name: "index_urlreports_on_date"
  end

  create_table "urls", force: :cascade do |t|
    t.string "longurl"
    t.string "shorturl"
    t.string "suffix"
    t.index ["longurl"], name: "index_urls_on_longurl"
    t.index ["shorturl"], name: "index_urls_on_shorturl"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
