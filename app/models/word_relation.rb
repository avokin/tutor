class WordRelation < ActiveRecord::Base
  belongs_to :source_word, :class_name => 'Word', :foreign_key => :source_word_id
  belongs_to :related_word,  :class_name => 'Word', :foreign_key => :related_word_id
end
