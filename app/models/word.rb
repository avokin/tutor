class Word < ActiveRecord::Base
  has_many :direct_translations, :class_name => 'Translation', :foreign_key => 'source_word_id'
  has_many :words1, :through => :direct_translations, :source => :translated_word

  has_many :backward_translations, :class_name => 'Translation', :foreign_key => 'translated_word_id'
  has_many :words2, :through => :backward_translations, :source => :source_word

  def words
    words1 + words2
  end
end
