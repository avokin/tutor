class AddLanguageIdToUserCategories < ActiveRecord::Migration
  def change
    add_column :user_categories, :language_id, :integer

    UserCategory.all.each do |category|
      word = category.user_words.first
      if word
        category.update_attribute :language_id, word.language.id
      end
    end
  end
end
