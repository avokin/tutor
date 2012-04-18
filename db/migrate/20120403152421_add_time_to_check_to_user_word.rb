class AddTimeToCheckToUserWord < ActiveRecord::Migration
  def change
    add_column :user_words, :time_to_check, :datetime, :default => DateTime.now, :null => false
    remove_column :word_relations, :success_count
  end
end
