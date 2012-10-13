class UserAddTargetLanguageId < ActiveRecord::Migration
  def change
    add_column :users, :target_language_id, :integer,  :default => 2, :null => false;
  end
end
