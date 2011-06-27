class AddTypeToWordRelation < ActiveRecord::Migration
  def self.up
    rename_table :translations, :word_relations
    add_column :word_relations, :relation_type, :integer
    WordRelation.update_all('relation_type = 1')

    change_column :word_relations, :relation_type, :integer, :null => false
  end

  def self.down
    remove_column :word_relations, :relation_type
    rename_table :word_relations, :translations
  end
end
