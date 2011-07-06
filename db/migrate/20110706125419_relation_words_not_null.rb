class RelationWordsNotNull < ActiveRecord::Migration
  def self.up
    change_column :word_relations, :source_word_id, :integer, :null => false
    change_column :word_relations, :related_word_id, :integer, :null => false
  end

  def self.down
    change_column :word_relations, :source_word_id, :integer, :null => true
    change_column :word_relations, :related_word_id, :integer, :null => true
  end
end
