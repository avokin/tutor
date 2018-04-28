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

ActiveRecord::Schema.define(version: 20171119095747) do

  create_table "languages", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["name"], name: "IndexLanguageNameUnique", unique: true

  create_table "trainings", force: :cascade do |t|
    t.integer  "user_category_id"
    t.integer  "direction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          null: false
  end

  create_table "user_categories", force: :cascade do |t|
    t.string   "name",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                     null: false
    t.boolean  "is_default",  default: false, null: false
    t.integer  "language_id"
  end

  add_index "user_categories", ["name", "language_id", "user_id"], name: "IndexCategoryNameUnique", unique: true

  create_table "user_word_categories", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_word_id"
    t.integer  "user_category_id"
  end

  create_table "user_words", force: :cascade do |t|
    t.integer  "user_id",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "success_count",        default: 0,                     null: false
    t.datetime "time_to_check",        default: '2018-04-28 06:47:58', null: false
    t.string   "text",                                                 null: false
    t.integer  "language_id",                                          null: false
    t.integer  "type_id"
    t.integer  "custom_int_field1"
    t.string   "custom_string_field1"
    t.string   "transcription"
    t.string   "comment"
    t.integer  "request_count",        default: 0
  end

  add_index "user_words", ["user_id", "text", "language_id"], name: "IndexUserWordUnique", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",                               null: false
    t.integer  "native_language_id",     default: 1, null: false
    t.integer  "success_count",          default: 5, null: false
    t.integer  "target_language_id",     default: 2, null: false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "IndexUserEmailUnique", unique: true

  create_table "word_relations", force: :cascade do |t|
    t.integer  "source_user_word_id",  null: false
    t.integer  "related_user_word_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relation_type",        null: false
    t.integer  "user_id",              null: false
    t.integer  "status_id",            null: false
    t.integer  "subtype_id"
  end

  add_index "word_relations", ["source_user_word_id", "related_user_word_id", "relation_type", "user_id"], name: "IndexWordRelationUnique", unique: true

end
