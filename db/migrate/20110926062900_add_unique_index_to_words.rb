class AddUniqueIndexToWords < ActiveRecord::Migration
  def self.up
    add_index(:words, [:word, :language_id], {:name => 'IndexWordLanguageUnique', :unique => true})
    add_index(:languages, :name, {:name => 'IndexLanguageNameUnique', :unique => true})
  end

  def self.down
    remove_index(:words, :name => 'IndexWordLanguageUnique')
    remove_index(:languages, :name => 'IndexLanguageNameUnique')
  end
end
