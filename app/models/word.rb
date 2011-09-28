class Word < ActiveRecord::Base
  validates :text, :presence => true
end
