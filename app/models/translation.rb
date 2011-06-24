class Translation < ActiveRecord::Base
  belongs_to :source_word, :class_name => 'Word', :foreign_key => :source_word_id
  belongs_to :translated_word,  :class_name => 'Word', :foreign_key => :translated_word_id
end
