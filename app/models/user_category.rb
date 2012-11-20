class UserCategory < ActiveRecord::Base
  attr_accessible :is_default, :name, :user

  has_many :user_word_categories, :dependent => :delete_all
  has_many :user_words, :through => :user_word_categories
  has_many :trainings, :dependent => :delete_all
  belongs_to :user

  def self.find_by_user_and_name(user, name)
    UserCategory.where(:user_id => user.id).where(:name => name).first
  end

  def self.merge(user, merging_category_ids)
    ok = false
    UserCategory.transaction do
      merging_category_ids.each do |id|
        category = UserCategory.find id

        if category.user == user
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
