class Change < ActiveRecord::Migration
  def up
    remove_index :user_categories, :name => 'IndexCategoryNameUnique'
    add_index :user_categories, [:name, :language_id, :user_id], {:name => 'IndexCategoryNameUnique', :unique => true}
  end

  def down
    remove_index :user_categories, :name => 'IndexCategoryNameUnique'
    add_index :user_categories, :name, {:name => 'IndexCategoryNameUnique', :unique => true}
  end
end
