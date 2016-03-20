module UserWordsHelper
  include Translation::GermanLanguage
  include Translation::Multitran

  def get_german_gender_by_number(number)
    number.nil? ? '' : GERMAN_GENDERS[number - 1][1]
  end

  def get_german_artikel_by_number(number)
    number.nil? ? '' : GERMAN_GENDERS[number - 1][0]
  end

  def get_german_gender_by_artikel(artikel)
    GERMAN_GENDERS.each do |gender|
      if gender[0] == artikel
        return gender[gender.length - 1]
      end
    end
    1
  end

  def get_german_plural_form(word)
    if word.custom_string_field1.nil? || word.custom_string_field1.length == 0
      ''
    else
      word.custom_string_field1
    end
  end

  def get_german_short_plural_form(word)
    if word.custom_string_field1.nil? || word.custom_string_field1.length == 0
      ''
    else
      '(' + word.custom_string_field1 + ')'
    end
  end

  def german_noun_gender_options
    options_for_select(GERMAN_GENDERS, @user_word.custom_int_field1)
  end

  def german_part_of_speech
    options_for_select(Translation::GermanLanguage::GERMAN_PART_OF_SPEECH, @user_word.type_id)
  end

  def edit_word_customization(form)
    if @user_word.language.is_german
      if @user_word.type_id == 2
        render 'user_words/edit_german_noun', :f => form
      else
        render 'user_words/edit_german_default', :f => form
      end
    else
      render 'user_words/edit_default', :f => form
    end
  end

  def show_word_customization
    if @user_word.language.is_german
      if @user_word.type_id == 2
        render 'user_words/show_german_noun'
      else
        render 'user_words/show_default'
      end
    else
      render 'user_words/show_default'
    end
  end
end
