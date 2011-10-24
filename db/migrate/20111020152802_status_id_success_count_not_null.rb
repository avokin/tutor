class StatusIdSuccessCountNotNull < ActiveRecord::Migration
  def self.up
    change_column :word_relations, :status_id, :integer, :null => false
    change_column :word_relations, :success_count, :integer, :null => false
  end

  def self.down
    change_column :word_relations, :status_id, :integer, :null => true
    change_column :word_relations, :success_count, :integer, :null => true
  end
end
