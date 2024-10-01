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

ActiveRecord::Schema[7.1].define(version: 2024_04_02_122749) do
  create_table "bugs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bugs_on_user_id"
  end

  create_table "committee_memberships", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "committee_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["committee_id"], name: "index_committee_memberships_on_committee_id"
    t.index ["person_id"], name: "index_committee_memberships_on_person_id"
  end

  create_table "committees", force: :cascade do |t|
    t.string "name"
    t.integer "api_committee_id"
    t.text "additional_info"
    t.string "additional_info_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "government_posts", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "additional_info"
    t.string "additional_info_link"
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "api_id"
    t.index ["person_id"], name: "index_government_posts_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer "party"
    t.string "role"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "member_id"
    t.datetime "membership_start_date"
    t.datetime "membership_end_date"
    t.boolean "active_status"
    t.string "email"
    t.string "portrait_url"
    t.string "constituency"
    t.integer "majority"
    t.float "area"
    t.integer "region_id"
    t.index ["region_id"], name: "index_people_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "related_update_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["related_update_id"], name: "index_taggings_on_related_update_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "updates", force: :cascade do |t|
    t.text "content"
    t.integer "person_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "occasion"
    t.date "comment_date"
    t.index ["person_id"], name: "index_updates_on_person_id"
    t.index ["user_id"], name: "index_updates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bugs", "users"
  add_foreign_key "committee_memberships", "committees"
  add_foreign_key "committee_memberships", "people"
  add_foreign_key "government_posts", "people"
  add_foreign_key "people", "regions"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "updates", column: "related_update_id"
  add_foreign_key "updates", "people"
  add_foreign_key "updates", "users"
end
