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

  def select_user_word(user, training)
    # ToDo:
    type = :translation

    if training.user_category.nil?
      user_words = user.user_words
    else
      user_category = training.user_category
      if user_category.user == user
        user_words = user_category.user_words
      else
        # ToDo
        #log error
        user_words = user.user_words
      end
    end

    if type == :translation
      if training.direction == :direct
        user_words = user_words.joins(:direct_translations)
      else
        user_words = user_words.joins(:backward_translations)
      end
    else
      user_words = user_words.joins(:direct_synonyms)
    end

    now = DateTime.now
    user_words = user_words.where("time_to_check <= ?", now)

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
