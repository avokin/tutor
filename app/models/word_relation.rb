class WordRelation < ActiveRecord::Base
  attr_accessible :status_id, :related_user_word_id, :relation_type, :related_user_word, :user, :source_user_word

  belongs_to :source_user_word, :class_name => 'UserWord', :foreign_key => :source_user_word_id
  belongs_to :related_user_word,  :class_name => 'UserWord', :foreign_key => :related_user_word_id
  belongs_to :user

  validates :relation_type, :presence => true
  validates :source_user_word, :presence => true
  validates :related_user_word, :presence => true
  validates :status_id, :presence => true
  validates :user, :presence => true

  validates_uniqueness_of :relation_type, :scope => [:source_user_word_id, :related_user_word_id]

  def self.create_relation(user, user_word, translated_text, relation_type)
    if relation_type == "1"
      language = user.language
    else
      language = user_word.language
    end
    related_user_word = UserWord.get_for_user(user, translated_text, language)
    if related_user_word.invalid? || related_user_word.invalid?
      return nil
    end

    case relation_type
      when "1"
        if related_user_word.language_id == user_word.language_id
          return nil
        end
        word_relation = user_word.direct_translations.build(:status_id => 1)
        word_relation.relation_type = 1
      when "2"
        if related_user_word.language_id != user_word.language_id || related_user_word == user_word
          return nil
        end

        word_relation = user_word.direct_synonyms.build(:status_id => 1)
        word_relation.relation_type = 2
      else
        word_relation = nil
    end
    if (!word_relation.nil?)
      word_relation.user = user
      word_relation.related_user_word = related_user_word
      if (word_relation.valid? || word_relation.source_user_word_id.nil?)
        word_relation.save()
      else
        word_relation = nil
      end
    end
    word_relation
  end

  def self.find_all_translation(user, text)
    WordRelation.where(:user_id => user.id).where(:relation_type => 1).joins(:source_user_word => :word).where(:words => {:text => text})
  end

  def self.find_all_by_user_id_relation_type_status_id(user, relation_type, status_id, category)
    if !category.nil?
      WordRelation.where(:user_id => user.id, :relation_type => relation_type, :status_id => status_id).joins(:source_user_word => :user_categories).where(:user_categories => {:id => category})
    else
      WordRelation.where(:user_id => user.id, :relation_type => relation_type, :status_id => status_id)
    end
  end
end
