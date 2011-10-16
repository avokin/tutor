class UserWordCategory < ActiveRecord::Base
  belongs_to :user_word
  belongs_to :user_category

  def self.create_word_category(word, category_name)
    category = UserCategory.find_by_name(category_name)
    if (category.nil?)
      category = UserCategory.new :name => category_name
      if !category.save
        raise ActiveRecord::Rollback
      end
    end

    word_category = UserWordCategory.new :word_id => word.id, :category_id => category.id
    if !word_category.save
      raise ActiveRecord::Rollback
    end
  end
end
