class UserWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :user

  has_many :direct_translations, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all
  has_many :backward_translations, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all

  has_many :direct_synonyms, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all
  has_many :backward_synonyms, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all

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
    result = find_for_user(user, text)
    if result.nil?
      word = Word.find_by_text(text)
      if (word.nil?)
        word = Word.new(:text => text, :language_id => language_id)
      end
      result = UserWord.new(:user => user, :word => word)
    end
    result
  end

  def save_with_relations(user, text, new_translations, new_synonyms, new_categories)
    UserWord.transaction do
      if (!text.nil?)
        word = Word.find_by_text(text)
        if (word.nil?)
          word = Word.new(:text => text, :language_id => 1)
        end
        self.word = word
      end

      if self.valid? && self.word.valid?
        if self.save
          logger.debug("UserWord saved correctly")
          new_translations.each do |translation|
            WordRelation.create_relation(user, self, translation, "1")
          end
          logger.debug "translations saved correctly"

          new_synonyms.each do |synonym|
            WordRelation.create_relation(user, self, synonym, "2")
          end
          logger.debug "synonyms saved correctly"

          #new_categories.each do |category|
          #  WordCategory.create_word_category(self, category)
          #end
          #logger.debug "user_categories saved correctly"
          return true
        end
      end
    end
    false
  end

  def self.find_for_user(user, text)
    where(:user_id => user.id).joins(:word).where(:words => {:text => text}).first
  end

  def self.find_recent_for_user(user, count)
    UserWord.order('created_at').where(:user_id => user.id).limit(count)
  end

end