class WordRelation < ActiveRecord::Base
  belongs_to :source_user_word, :class_name => 'UserWord', :foreign_key => :source_user_word_id
  belongs_to :related_user_word,  :class_name => 'UserWord', :foreign_key => :related_user_word_id
  belongs_to :user

  validates :relation_type, :presence => true
  validates :source_user_word_id, :presence => true
  validates :related_user_word_id, :presence => true
  validates :user_id, :presence => true

  def self.create_relation(user, user_word, translated_text, relation_type)
    WordRelation
    related_user_word = UserWord.get_for_user(user, translated_text, user_word.word.language_id == 1 ? 2 : 1)
    related_user_word.save()

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
    word_relation.user_id = user.id
    if (!word_relation.nil?)
      word_relation.related_user_word = related_user_word
      if (!word_relation.valid?)
        puts "not valid"
      end
      word_relation.save()
    end
  end
end
