class CreateWordCategories < ActiveRecord::Migration
  def self.up
    create_table :word_categories do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :word_categories
  end
end
