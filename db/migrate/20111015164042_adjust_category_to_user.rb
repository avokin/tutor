class AdjustCategoryToUser < ActiveRecord::Migration
  def self.up
    rename_table :categories, :user_categories
    add_column :user_categories, :user_id, :integer
    UserCategory.update_all ['user_id = ?', 1]
    change_column :user_categories, :user_id, :integer, :null => false

    rename_table :word_categories, :user_word_categories
    rename_column :user_word_categories, :word_id, :user_word_id
    rename_column :user_word_categories, :category_id, :user_category_id
  end

  def self.down
    rename_table :user_word_categories, :word_categories
    remove_column :user_categories, :user_id
    rename_table :user_categories, :categories
  end
end
