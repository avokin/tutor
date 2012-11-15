module UserWordsHelper
  include Translation::GermanLanguage

  def get_german_gender_by_number(number)
    unless number.nil?
      @@german_genders[number - 1][0]
    else
      ""
    end
  end

  def get_german_gender_by_artikel(artikel)
    @@german_genders.each do |gender|
      if gender[0] == artikel
        return gender[2]
      end
    end
    1
  end

  def get_german_plural_form(word)
    unless word.custom_string_field1.nil? || word.custom_string_field1.length == 0
      "(" + word.custom_string_field1 + ")"
    else
      ""
    end
  end

  def german_noun_gender_options
    options_for_select(@@german_genders, @user_word.custom_int_field1)
  end

  def german_part_of_speech
    options_for_select(@@german_parts_of_speech, @user_word.type_id)
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
        render "user_words/show_default"
      end
    else
      render "user_words/show_default"
    end
  end
end
