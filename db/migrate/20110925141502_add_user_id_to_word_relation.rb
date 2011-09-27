class AddUserIdToWordRelation < ActiveRecord::Migration
  def self.up
    add_column :word_relations, :user_id, :integer
  end

  def self.down
    remove_column :word_relations, :user_id
  end
end
