class CreateUserWords < ActiveRecord::Migration
  def self.up
    create_table :user_words do |t|
      t.integer :user_id
      t.integer :word_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_words
  end
end
