class AddTranslationSuccessCountToUserWord < ActiveRecord::Migration
  def change
    add_column :user_words, :translation_success_count, :int, :default => 0, :null => false
  end
end
