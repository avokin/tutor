class UserWordCategory < ActiveRecord::Base
  belongs_to :user_word
  belongs_to :user_category

  def self.create_word_category(user_word, category_name)
    user_category = UserCategory.find_by_name(category_name)
    if (user_category.nil?)
      user_category = UserCategory.new :name => category_name, :user => user_word.user
      if !user_category.save
        raise ActiveRecord::Rollback
      end
    end

    word_category = UserWordCategory.new :user_word_id => user_word.id, :user_category_id => user_category.id
    if !word_category.save
      raise ActiveRecord::Rollback
    end
  end
end
