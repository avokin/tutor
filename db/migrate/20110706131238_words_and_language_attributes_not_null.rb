class WordsAndLanguageAttributesNotNull < ActiveRecord::Migration
  def self.up
    change_column :words, :language_id, :integer, :null => false
    change_column :words, :word, :string, :null => false
    change_column :languages, :name, :string, :null => false
  end

  def self.down
    change_column :words, :language_id, :integer, :null => true
    change_column :words, :word, :string, :null => true
    change_column :languages, :name, :string, :null => true
  end

end
