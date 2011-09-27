class NotNullsAndIndexesFixed < ActiveRecord::Migration
  def self.up
    change_column :categories, :name, :string, :null => false
    add_index :categories, :name, {:name => 'IndexCategoryNameUnique', :unique => true}

    change_column :user_words, :user_id, :integer, :null => false
    change_column :user_words, :word_id, :integer, :null => false
    add_index :user_words, [:user_id, :word_id], {:name => 'IndexUserWordUnique', :unique => true}

    change_column :users, :name, :string, :null => false
    change_column :users, :email, :string, :null => false
    change_column :users, :encrypted_password, :string, :null => false
    change_column :users, :salt, :string, :null => false
    add_index :users, :email, {:name => 'IndexUserEmailUnique', :unique => true}

    change_column :word_relations, :user_id, :integer, :null => false
    add_index :word_relations, [:source_user_word_id, :related_user_word_id, :relation_type, :user_id], {:name => 'IndexWordRelationUnique', :unique => true}
  end

  def self.down
    remove_index :categories, :name => 'IndexCategoryNameUnique'
    change_column :categories, :name, :string, :null => true

    remove_index :user_words, :name => 'IndexUserWordUnique'
    change_column :user_words, :user_id, :integer, :null => true
    change_column :user_words, :word_id, :integer, :null => true

    remove_index :users, :name => 'IndexUserEmailUnique'
    change_column :users, :name, :string, :null => true
    change_column :users, :email, :string, :null => true
    change_column :users, :encrypted_password, :string, :null => true
    change_column :users, :salt, :string, :null => true

    remove_index :word_relations, :name => 'IndexWordRelationUnique'
    change_column :word_relations, :user_id, :integer, :null => true
  end
end
