class GermanMultitranParser
  include Translation::GermanLanguage

  def parse(doc, word)
    type_id = 1
    custom_int_field1 = nil
    custom_string_field1 = nil

    grammar = doc.css('em')[0]
    if grammar
      translation_container = grammar.parent.parent.next

      translation_tds = translation_container.css('td')
      if translation_tds.count > 1
        processed = Array.new
        translations = translation_tds[1].css('a')

        translations.each do |translation|
          if translation.attributes['href'].content =~ /UserName/
            next
          end

          if word.direct_translations.length > 2
            break
          end

          unless processed.include?(translation.content)
            translation_word = UserWord.new(:text => translation.content, :user => word.user, :language => word.user.language)
            relation = WordRelation.new({ :status_id => 1, :user => word.user, :relation_type => '1',
                                          :source_user_word => word, :related_user_word => translation_word })

            word.direct_translations << relation
            processed << translation.content
          end
        end
      end

      grammar_content = grammar.content
      if grammar_content =~ /^сущ/
        gender = grammar_content[5, 1]
        custom_int_field1 = get_gender_id(gender)
        grammar_items = grammar_content.split(',')
        custom_string_field1 = grammar_items[-1].strip
        type_id = 2
      elsif grammar_content =~ /^гл/
        type_id = 3
      end
    end

    if word.type_id.nil?
      word.assign_attributes :type_id => type_id
    end
    word.assign_attributes :custom_int_field1 => custom_int_field1, :custom_string_field1 => custom_string_field1
  end
end