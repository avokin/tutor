class FixTranslationWordIdColumnName < ActiveRecord::Migration
  def self.up
    rename_column :translations, :word_id, :source_word_id
  end

  def self.down
    rename_column :translations, :source_word_id, :word_id
  end
end
