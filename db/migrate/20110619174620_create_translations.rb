class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.integer :word_id
      t.integer :translated_word_id

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
