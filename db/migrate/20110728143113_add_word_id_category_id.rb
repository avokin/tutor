class AddWordIdCategoryId < ActiveRecord::Migration
  def self.up
    add_column :word_categories, :word_id, :integer, :references => :words
    add_column :word_categories, :category_id, :integer, :references => :categories
  end

  def self.down
    remove_column :word_categories, :word_id
    remove_column :word_categories, :category_id
  end
end
