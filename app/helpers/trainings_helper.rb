module TrainingsHelper
  def learning_word_customization(word)
    if word.language.is_german
      if word.type_id == 2
        return 'trainings/german_noun.js.erb'
      end
    end
    'trainings/word.js.erb'
  end

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
end
