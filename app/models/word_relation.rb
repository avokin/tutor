class WordRelation < ActiveRecord::Base
  belongs_to :source_user_word, :class_name => 'UserWord', :foreign_key => :source_user_word_id
  belongs_to :related_user_word,  :class_name => 'UserWord', :foreign_key => :related_user_word_id
  belongs_to :user

  validates :relation_type, :presence => true
  validates :source_user_word, :presence => true
  validates :related_user_word, :presence => true
  validates :status_id, :presence => true
  validates :user, :presence => true

  validates_uniqueness_of :relation_type, :scope => [:source_user_word_id, :related_user_word_id]
  validate :backward_relation

  def self.create_relation(user, user_word, translated_text, relation_type)
    if relation_type == '1'
      language = user.language
    else
      language = user_word.language
    end
    related_user_word = UserWord.get_for_user(user, translated_text, language)
    if related_user_word.invalid? || related_user_word.invalid?
      return nil
    end

    case relation_type
      when '1'
        if related_user_word.language_id == user_word.language_id
          return nil
        end
        word_relation = user_word.direct_translations.build(:status_id => 1)
        word_relation.relation_type = 1
      when '2'
        if related_user_word.language_id != user_word.language_id || related_user_word == user_word
          return nil
        end

        word_relation = user_word.direct_synonyms.build(:status_id => 1)
        word_relation.relation_type = 2
      else
        word_relation = nil
    end
    unless word_relation.nil?
      word_relation.user = user
      word_relation.related_user_word = related_user_word
      if word_relation.valid? || word_relation.source_user_word_id.nil?
        word_relation.save
      else
        word_relation = nil
      end
    end
    word_relation
  end

  def backward_relation
    backward_relation = WordRelation.find_by(source_user_word_id: self.related_user_word_id,
                         related_user_word_id: self.source_user_word_id,
                         relation_type: self.relation_type)

    if backward_relation
      errors.add(:related_user_word_id, 'Must be unique')
    end
  end
end
