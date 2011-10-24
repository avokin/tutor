class UserAttributes < ActiveRecord::Migration
  def self.up
    add_column :users, :native_language_id, :integer, :default => 2, :null => false
    add_column :users, :success_count, :integer, :default => 5, :null => false

  end

  def self.down
    remove_column :users, :success_count
    remove_column :users, :native_language_id
  end
end
