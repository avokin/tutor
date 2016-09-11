class RemovingWordCompletely < ActiveRecord::Migration
  def change
    remove_index :user_words, :name => 'IndexUserWordUnique'
    drop_table :words

    remove_column :user_words, :word_id
    change_column :user_words, :text, :string, :null => false
    change_column :user_words, :language_id, :integer, :null => false

    add_index :user_words, [:user_id, :text, :language_id], {:name => 'IndexUserWordUnique', :unique => true}
  end
end
