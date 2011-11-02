class Word < ActiveRecord::Base
  validates :text, :presence => true
  has_many :user_words, :dependent => :delete_all

  belongs_to :language
end
