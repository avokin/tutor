class DefaultLanguageIsFirst < ActiveRecord::Migration
  def change
    change_column :users, :native_language_id, :integer, :default => 1, :null => false
  end
end
