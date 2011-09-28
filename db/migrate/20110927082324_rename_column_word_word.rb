class RenameColumnWordWord < ActiveRecord::Migration
  def self.up
    rename_column :words, :word, :text
  end

  def self.down
    rename_column :words, :text, :word
  end
end
