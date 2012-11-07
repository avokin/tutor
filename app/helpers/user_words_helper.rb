module UserWordsHelper
  @@german_genders = [["", 1], ["der", 2], ["die", 3], ["das", 4]]

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

  def get_training_status(user_word)
    if user_word.translation_success_count < UserWord::TIME_LAPSES.length - 1
      100 * user_word.translation_success_count / (UserWord::TIME_LAPSES.length - 1)
    else
      100
    end
  end

  def get_german_gender(number)
    @@german_genders[number - 1][0]
  end

  def german_noun_gender_options
    options_for_select(@@german_genders, @user_word.custom_string_field1)
  end

  def german_part_of_speech
    options_for_select([["", 1], ["noun", 2], ["verb", 3]], @user_word.type_id)
  end

  def edit_word_customization(form)
    if @user_word.language == Language.find_by_name("Deutsch")
      if @user_word.type_id == 2
        render "user_words/edit_german_noun", :f => form
      else
        render "user_words/edit_german_default", :f => form
      end
    else
      render "user_words/edit_default"
    end
  end

  def show_word_customization
    if @user_word.language == Language.find_by_name("Deutsch")
      if @user_word.type_id == 2
        render "user_words/show_german_noun"
      else
        render "user_words/show_german_default"
      end
    else
      render "user_words/show_default"
    end
  end

end
