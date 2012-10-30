module TrainingsHelper

  def check_answers(user_word, answers, answer_statuses)
    result = true
    user_word.direct_translations.each do |t|
      if answers.include?(t.related_user_word.text)
        answer_statuses[t.related_user_word.text] = true
      else
        result = false
      end
    end
    if result
      user_word.success_attempt
    else
      user_word.fail_attempt
    end
    user_word.save!
    result
  end

  def skip(user_word)
  end

  def select_user_word(training, page)
    user_words = training.get_ready_user_words(page)
    count = user_words.length
    if count == 0
      nil
    else
      pos = rand(count)
      user_words[pos]
    end
  end
end
