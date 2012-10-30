class UserWord < ActiveRecord::Base
  attr_accessible :translation_success_count, :text, :user, :time_to_check, :language_id
  belongs_to :user
  belongs_to :language

  has_many :direct_translations, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all
  has_many :backward_translations, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 1', :dependent => :delete_all

  has_many :direct_synonyms, :class_name => 'WordRelation', :foreign_key => 'source_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all
  has_many :backward_synonyms, :class_name => 'WordRelation', :foreign_key => 'related_user_word_id', :conditions => 'relation_type = 2', :dependent => :delete_all

  has_many :user_word_categories
  has_many :user_categories, :through => :user_word_categories

  validates :text, :presence => true
  validates :user, :presence => true
  validates :time_to_check, :presence => true

  after_initialize :set_time_to_check

  TIME_LAPSES = [4.hours, 8.hours, 3, 7, 30, 60]

  def translations
    direct_translations + backward_translations
  end

  def synonyms
    direct_synonyms + backward_synonyms
  end

  def rename(new_name)
    self.update_attributes(:text => new_name)
  end

  def self.get_for_user(user, text, language_id)
    result = find_for_user(user, text)
    if result.nil?
      result = UserWord.new(:user => user, :text => text, :language_id => language_id)
    end
    result
  end

  def save_with_relations(user, text, new_translations, new_synonyms, new_categories)
    UserWord.transaction do
      unless text.nil?
        self.text = text
      end

      self.user = user
      self.language = user.target_language

      if self.valid? && self.valid?
        if self.save
          logger.debug("UserWord saved correctly")
          new_translations.each do |translation|
            if user.language.id != self.language.id
              WordRelation.create_relation(user, self, translation, "1")
            else
              related_user_word = UserWord.get_for_user(user, translation, user.target_language.id)
              if related_user_word.new_record?
                related_user_word.save!
              end
              WordRelation.create_relation(user, related_user_word, self.text, "1")
            end
          end
          logger.debug "translations saved correctly"

          new_synonyms.each do |synonym|
            WordRelation.create_relation(user, self, synonym, "2")
          end
          logger.debug "synonyms saved correctly"

          new_categories.each do |category|
            UserWordCategory.create_word_category(self, category)
          end
          logger.debug "user_categories saved correctly"
          return true
        end
      end
    end
    false
  end

  def self.find_for_user(user, text)
    where(:user_id => user.id).where(:text => text).first
  end

  def self.find_recent_for_user(user, count)
    UserWord.order('created_at desc').where(:user_id => user.id).limit(count)
  end

  def fail_attempt
    self.translation_success_count = 0
    self.time_to_check = DateTime.now + TIME_LAPSES[0]
  end

  def success_attempt
    k = [TIME_LAPSES.length - 1, self.translation_success_count].min
    self.time_to_check = DateTime.now + TIME_LAPSES[k]
    self.translation_success_count += 1
  end

  def save_attempt(ok)
    if ok
      success_attempt
    else
      fail_attempt
    end
    save!
  end

  private
  def set_time_to_check
    # ToDo
    #if self.time_to_check.nil?
    #  self.time_to_check = Time.now
    #end
  end
end
