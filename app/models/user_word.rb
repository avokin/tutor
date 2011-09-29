class UserWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :user

  has_many :direct_translations, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all
  has_many :backward_translations, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all

  has_many :direct_synonyms, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all
  has_many :backward_synonyms, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all

  #has_many :word_categories, :dependent => :delete_all

  validates :word, :presence => true
  validates :user, :presence => true

  def translations
    direct_translations + backward_translations
  end

  def synonyms
    direct_synonyms + backward_synonyms
  end

  def rename(new_name)
    UserWord.transaction do
      word = Word.find_by_text(new_name)
      if (word.nil?)
        word = Word.new(:text => new_name, :language_id => self.word.language_id)
        if (!word.valid?)
          raise ActiveRecord::Rollback
        end
        word.save()  #ToDo: cascade update
      end
      self.word = word
      update()
    end
  end

  def self.get_for_user(user, text, language_id)
    word = Word.find_by_text(text)
    if (word.nil?)
      word = Word.new(:text => text, :language_id => language_id)
    end

    UserWord.new(:user => user, :word => word)
  end

  def self.save_with_relations(user, text, new_translations, new_synonyms, new_categories)
    user_word = UserWord.new :user_id => user.id
    UserWord.transaction do
      word = Word.find_by_text(text)
      if (word.nil?)
        word = Word.new(:text => text, :language_id => 1)
        if !word.valid?
          raise ActiveRecord::Rollback
        end
      end
      user_word.word = word
      if user_word.new_record? && user_word.save
        logger.debug("UserWord saved correctly")
        new_translations.each do |translation|
          WordRelation.create_relation(user, user_word, translation, "1")
        end
        logger.debug "translations saved correctly"

        new_synonyms.each do |synonym|
          WordRelation.create_relation(user, user_word, synonym, "2")
        end
        logger.debug "synonyms saved correctly"

        #new_categories.each do |category|
        #  WordCategory.create_word_category(self, category)
        #end
        #logger.debug "categories saved correctly"
        return user_word
      end
    end
    nil
  end

  def self.find_for_user(user, text)
     UserWord.where(:user_id => user.id).joins(:word).where(:words => {:text => text}).first
  end
end
