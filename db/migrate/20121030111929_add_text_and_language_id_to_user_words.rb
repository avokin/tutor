class AddTextAndLanguageIdToUserWords < ActiveRecord::Migration
  def change
    add_column :user_words, :text, :string

    add_column :user_words, :language_id, :integer
  end
end
