class WordCategory < ActiveRecord::Base
  belongs_to :word
  belongs_to :category

  def self.create_word_category(word, category_name)
    category = Category.find_by_name(category_name)
    if (category.nil?)
      category = Category.new :name => category_name
      if !category.save
        raise ActiveRecord::Rollback
      end
    end

    word_category = WordCategory.new :word_id => word.id, :category_id => category.id
    if !word_category.save
      raise ActiveRecord::Rollback
    end
  end
end
