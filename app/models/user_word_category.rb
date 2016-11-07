class UserWordCategory < ActiveRecord::Base
  belongs_to :user_word
  belongs_to :user_category

  validate :language_of_category_and_word
  validate :user_of_category_and_word

  def self.create_word_category(user_word, category_name)
    user_category = UserCategory.where(name: category_name, user_id: user_word.user_id).take
    if user_category.nil?
      user_category = UserCategory.new :name => category_name, :user => user_word.user, :language => user_word.language
      unless user_category.save
        raise ActiveRecord::Rollback
      end
    end

    word_category = UserWordCategory.new :user_word_id => user_word.id, :user_category_id => user_category.id
    unless word_category.save
      raise ActiveRecord::Rollback
    end
  end

  private
  def language_of_category_and_word
    if self.user_category.language != self.user_word.language
      errors.add(:user_category, "language of the category doesn't match to language of the word")
    end
  end

  def user_of_category_and_word
    if self.user_category.user != self.user_word.user
      errors.add(:user_category, "user of the category doesn't match to user of the word")
    end
  end
end
