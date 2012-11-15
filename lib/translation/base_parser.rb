class BaseParser
  def process_translation(translation, word, processed)
    if !processed.include?(translation)
      translation_word = UserWord.new(:text => translation, :user => word.user, :language => word.user.language)
      relation = WordRelation.new({:status_id => 1, :user => word.user, :relation_type => "1", :source_user_word => word, :related_user_word => translation_word})

      word.direct_translations << relation
      processed << translation
    end
  end
end