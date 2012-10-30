class UserWordWordIdIsNullable < ActiveRecord::Migration
  def change
    change_column :user_words, :word_id, :integer, :null => true
  end
end
