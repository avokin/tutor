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

  def create_with_translations_and_categories(params)
    # ToDo: work out params in controller

    Word.transaction do
      begin
        if (self.save)
          i = 0
          while !params["translation_#{i}"].nil? do
            translation = params["translation_#{i}"]
            # ToDo:
            relation = WordRelation.create_relation(self, translation, "1")
            unless relation.nil?
              relation.save
            end
            i = i + 1
          end

          i = 0
          while !params["category_#{i}"].nil? do
            category_name = params["category_#{i}"]
            WordCategory.create_word_category(self, category_name)
            i = i + 1
          end
        end
      rescue
        return false
      end
    end
    true
  end
end
