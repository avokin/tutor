class RenameColumnsWordToUserWord < ActiveRecord::Migration
  def self.up
    rename_column :word_relations, :source_word_id, :source_user_word_id
    rename_column :word_relations, :related_word_id, :related_user_word_id
  end

  def self.down
    rename_column :word_relations, :source_user_word_id, :source_word_id
    rename_column :word_relations, :related_user_word_id, :related_word_id
  end
end
