class Word < ActiveRecord::Base
  has_many :direct_translations, :class_name => 'WordRelation', :foreign_key => 'source_word_id', :conditions => 'relation_type = 1'
  has_many :backward_translations, :class_name => 'WordRelation', :foreign_key => 'related_word_id', :conditions => 'relation_type = 1'

  has_many :direct_synonyms, :class_name => 'WordRelation', :foreign_key => 'source_word_id', :conditions => 'relation_type = 2'
  has_many :backward_synonyms, :class_name => 'WordRelation', :foreign_key => 'related_word_id', :conditions => 'relation_type = 2'

  has_many :word_categories, :dependent => :delete_all

  validates :word, :presence => true

  def translations
    direct_translations + backward_translations
  end

  def synonyms
    direct_synonyms + backward_synonyms
  end

  def save_with_children(new_translations, new_synonyms, new_categories)
    begin
      Word.transaction do
        if self.new_record? && self.save || !self.new_record? && self.update_attributes(:word => self.word)
          logger.debug("word saved correctly")
          new_translations.each do |translation|
            relation = WordRelation.create_relation(self, translation, "1")
            unless relation.nil?
              relation.save!
            end
          end
          logger.debug "translations saved correctly"

          new_synonyms.each do |synonym|
            relation = WordRelation.create_relation(self, synonym, "2")
            unless relation.nil?
              relation.save!
            end
          end
          logger.debug "synonyms saved correctly"

          new_categories.each do |category|
            WordCategory.create_word_category(self, category_name)
          end
          logger.debug "categories saved correctly"
        end
      end
    rescue
      logger.error "error during saving word or categories"
      return false
    end
    true
  end
end
