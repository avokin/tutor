class RenameTranslationSuccessCountToSuccessCount < ActiveRecord::Migration
  def change
    rename_column :user_words, :translation_success_count, :success_count
  end
end
