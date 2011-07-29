class Category < ActiveRecord::Base
  has_many :word_categories, :dependent => :delete_all
  has_many :words, :through => :word_categories
end
