class UserCategory < ActiveRecord::Base
  attr_accessible :is_default, :name, :user

  has_many :user_word_categories, :dependent => :delete_all
  has_many :user_words, :through => :user_word_categories
  has_many :trainings, :dependent => :delete_all
  belongs_to :user

  def self.find_by_user_and_name(user, name)
    UserCategory.where(:user_id => user.id).where(:name => name).first
  end
end
