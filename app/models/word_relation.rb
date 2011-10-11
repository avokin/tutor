class WordRelation < ActiveRecord::Base
  attr_accessible :status_id, :success_count, :related_user_word_id, :relation_type

  belongs_to :source_user_word, :class_name => 'UserWord', :foreign_key => :source_user_word_id
  belongs_to :related_user_word,  :class_name => 'UserWord', :foreign_key => :related_user_word_id
  belongs_to :user

  validates :relation_type, :presence => true
  validates :source_user_word, :presence => true
  validates :related_user_word, :presence => true
  validates :user, :presence => true

  def self.create_relation(user, user_word, translated_text, relation_type)
    related_user_word = UserWord.get_for_user(user, translated_text, user_word.word.language_id == 1 ? 2 : 1)
    if (related_user_word.invalid? || related_user_word.word.invalid?)
      return nil
    end
    #related_user_word.save()

    case relation_type
      when "1"
        word_relation = user_word.direct_translations.build()
        word_relation.relation_type = 1
      when "2"
        word_relation = user_word.direct_synonyms.build()
        word_relation.relation_type = 2
      else
        word_relation = nil
    end
    if (!word_relation.nil?)
      word_relation.user = user
      word_relation.related_user_word = related_user_word
      if (word_relation.valid?)
        word_relation.save()
      else
        word_relation = nil
      end
    end
    word_relation
  end
end
