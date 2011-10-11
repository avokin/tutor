class AddStatusAndSubRelationTypeToWordRelation < ActiveRecord::Migration
  def self.up
    add_column :word_relations, :status_id, :integer
    add_column :word_relations, :success_count, :integer
    add_column :word_relations, :subtype_id, :integer
  end

  def self.down
    remove_column :word_relations, :subtype_id
    remove_column :word_relations, :success_count
    remove_column :word_relations, :status_id
  end
end
