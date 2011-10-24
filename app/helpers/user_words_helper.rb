module UserWordsHelper
  def word_status(user_word)
    learned_count = 0
    user_word.translations.each do |translation|
      if translation.status_id == 2
        learned_count += 1
      end
    end

    if user_word.translations.length > 0
      learned_count / user_word.translations.length
    else
      0
    end
  end
end
