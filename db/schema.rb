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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111007081340) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], :name => "IndexCategoryNameUnique", :unique => true

  create_table "languages", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["name"], :name => "IndexLanguageNameUnique", :unique => true

  create_table "user_words", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "word_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_words", ["user_id", "word_id"], :name => "IndexUserWordUnique", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "email",              :null => false
    t.string   "encrypted_password", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",               :null => false
  end

  add_index "users", ["email"], :name => "IndexUserEmailUnique", :unique => true

  create_table "word_categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "word_id"
    t.integer  "category_id"
  end

  create_table "word_relations", :force => true do |t|
    t.integer  "source_user_word_id",  :null => false
    t.integer  "related_user_word_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relation_type",        :null => false
    t.integer  "user_id",              :null => false
    t.integer  "status_id"
    t.integer  "success_count"
    t.integer  "subtype_id"
  end

  add_index "word_relations", ["source_user_word_id", "related_user_word_id", "relation_type", "user_id"], :name => "IndexWordRelationUnique", :unique => true

  create_table "words", :force => true do |t|
    t.string   "text",        :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "words", ["text", "language_id"], :name => "IndexWordLanguageUnique", :unique => true

end
