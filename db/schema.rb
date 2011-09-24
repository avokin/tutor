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

ActiveRecord::Schema.define(:version => 20110923085352) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_words", :force => true do |t|
    t.integer  "user_id"
    t.integer  "word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
  end

  create_table "word_categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "word_id"
    t.integer  "category_id"
  end

  create_table "word_relations", :force => true do |t|
    t.integer  "source_word_id",  :null => false
    t.integer  "related_word_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relation_type",   :null => false
  end

  create_table "words", :force => true do |t|
    t.string   "word",        :null => false
    t.integer  "language_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
