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

ActiveRecord::Schema.define(version: 20160417021411) do

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.string   "post_date"
    t.string   "description"
    t.boolean  "applied"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "company"
    t.string   "url"
    t.float    "score"
    t.string   "location"
    t.integer  "user_id"
    t.string   "logo"
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "github"
    t.string   "linkedin"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
