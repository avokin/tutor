class UserCategory < ActiveRecord::Base
  attr_accessible :is_default, :name, :user, :language

  has_many :user_word_categories, :dependent => :delete_all
  has_many :user_words, :through => :user_word_categories
  has_many :trainings, :dependent => :delete_all
  belongs_to :user
  belongs_to :language

  def self.find_by_user_and_name(user, name)
    UserCategory.where(:user_id => user.id).where(:name => name).first
  end

  def self.find_all_by_is_default(user)
    UserCategory.where(:user_id => user.id).where(:language_id => user.target_language.id).where(:is_default => true).all
  end

  def self.merge(user, merging_category_ids)
    ok = false
    first = UserCategory.find merging_category_ids[0]
    UserCategory.transaction do
      merging_category_ids.each do |id|
        category = UserCategory.find id

        if category.user == user && first.language_id == category.language_id
          UserWordCategory.update_all({:user_category_id => merging_category_ids[0]}, {:user_category_id => id})
          if id != merging_category_ids[0]
            category.destroy
          end
        else
          raise ActiveRecord::Rollback
        end
      end
      ok = true
    end
    ok
  end
end
