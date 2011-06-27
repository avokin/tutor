class FixTranslationWordColumnName < ActiveRecord::Migration
  def self.up
    rename_column :word_relations, :translated_word_id, :related_word_id
  end

  def self.down
    rename_column :word_relations, :related_word_id, :translated_word_id
  end
end
