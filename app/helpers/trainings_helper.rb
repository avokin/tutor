module TrainingsHelper
  def check_answers(user_word, answers, answer_statuses)
    result = true
    user_word.direct_translations.each do |t|
      if answers.include?(t.related_user_word.word.text)
        answer_statuses[t.related_user_word.word.text] = true
      else
        result = false
      end
    end
    if result
      user_word.translation_success_count += 1
    else
      user_word.translation_success_count = 0
    end
    user_word.save!
    result
  end

  def select_user_word(user, scope, direction, type, mode)
    if scope.nil?
      user_words = user.user_words
    else
      user_category = UserCategory.find(scope)
      if user_category.user == current_user
        user_words = user_category.user_words
      else
        #log error
        user_words = user.user_words
      end
    end

    if type == :translation
      if direction == :foreign_native
        user_words = user_words.joins(:direct_translations)
      else
        user_words = user_words.joins(:backward_translations)
      end
    else
      user_words = user_words.joins(:direct_synonyms)
    end

    if mode == :learning
      user_words = user_words.where("translation_success_count < ?", 5)
    else
      user_words = user_words.where("translation_success_count >= ?", 5)
    end

    count = user_words.length
    if count == 0
      nil
    elsif count == 1
      user_words[0]
    else
      pos = rand(count - 1)
      user_words[pos]
    end
  end
end
