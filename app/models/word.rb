class Word < ActiveRecord::Base
  has_many :direct_translations, :class_name => 'WordRelation', :foreign_key => 'source_word_id', :conditions => 'relation_type = 1'
  #has_many :words1, :through => :direct_translations, :source => :related_word

  has_many :backward_translations, :class_name => 'WordRelation', :foreign_key => 'related_word_id', :conditions => 'relation_type = 1'
  #has_many :words2, :through => :backward_translations, :source => :source_word

  has_many :direct_synonyms, :class_name => 'WordRelation', :foreign_key => 'source_word_id', :conditions => 'relation_type = 2'
  has_many :backward_synonyms, :class_name => 'WordRelation', :foreign_key => 'related_word_id', :conditions => 'relation_type = 2'

  def translations
    direct_translations + backward_translations
  end

  def synonyms
    direct_synonyms + backward_synonyms
  end
end
