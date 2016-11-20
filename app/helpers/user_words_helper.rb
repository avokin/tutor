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

  def create_or_update(user_word)
    new_translations = read_all_parameters_with_prefix('translation')
    new_synonyms = read_all_parameters_with_prefix('synonym')
    new_categories = read_all_parameters_with_prefix('category')

    user_word.user = current_user
    if word_params[:type_id]
      user_word.type_id = word_params[:type_id]
    end
    if word_params[:user_word]
      user_word.assign_attributes(word_params[:user_word])
    end
    user_word.save_with_relations(new_translations, new_synonyms, new_categories)
  end

  def permit_params(params)
    params.permit(:text, :type_id, :translation_0, :translation_1, :translation_2, :translation_3, :synonym_0,
                  :synonym_1, :synonym_2, :synonym_3, :category_0, :category_1, :category_2, :category_3, :language_id,
                  :user_word => [:language_id, :type_id, :text, :custom_int_field1, :custom_string_field1, :comment])
  end

  private

  def read_all_parameters_with_prefix(prefix)
    result = Array.new
    word_params[prefix + '_0'].split(';').each do |s|
      unless s.nil?
        value = s.strip
        if value.length > 0
          result << value
        end
      end
    end

    i = 1
    until (s = word_params[prefix + "_#{i}"]).nil? do
      result << s
      i += 1
    end
    result
  end
end
