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

  def select_user_word(scope)
    if scope.nil?
      user_words = current_user.user_words
    else
      user_category = UserCategory.find_by_user_and_name(current_user, scope)
      user_words = user_category.user_words
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
