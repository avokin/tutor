class WordRelation < ActiveRecord::Base
  belongs_to :source_word, :class_name => 'Word', :foreign_key => :source_word_id
  belongs_to :related_word,  :class_name => 'Word', :foreign_key => :related_word_id

  validates :relation_type, :presence => true
  validates :source_word_id, :presence => true

  def self.create_relation(word_id, translated_text, relation_type)
    word = Word.find(word_id)

    related_word = Word.find_by_word(translated_text)

    if (related_word.nil?)
      related_word = Word.new
      related_word.language_id = word.language_id == 1 ? 2 : 1
      related_word.word = translated_text

      if (!related_word.valid?)
        return nil
      end
    end

    case relation_type
      when "1"
        word_relation = word.direct_translations.build()
        word_relation.relation_type = 1
      when "2"
        word_relation = word.direct_synonyms.build()
        word_relation.relation_type = 2
      else
        word_relation = nil
    end
    if (!word_relation.nil?)
      word_relation.related_word = related_word
      if (!word_relation.valid?)
        puts "not valid"
      end
    end
    word_relation
  end
end
