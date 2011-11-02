class AddIsDefaultToUserCategory < ActiveRecord::Migration
  def self.up
    add_column :user_categories, :is_default, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :user_categories, :is_default
  end
end
