class GermanLingvoParser < DefaultLingvoParser
  include Translation::GermanLanguage

  def parse(doc, word)
    super doc, word

    gender = nil
    last = nil
    grammar_content = doc.css("p.P1 span.g-article__comment")[0]
    grammar_content_doc = Nokogiri::HTML(grammar_content.to_s)
    grammar_content_doc.css("span span").each do |comment|
      if comment.to_s =~ /(Neutrum|Maskulinum|Femininum)/
        gender = comment.content
      end
      last = comment.content
    end

    unless gender.nil?
      gender_id = nil
      i = 0
      while i < @@german_genders.length do
        gender_instance = @@german_genders[i]
        if gender_instance[2] == gender
          gender_id = gender_instance[gender_instance.length - 1]
        end
        i += 1
      end

      last = last.split(",").last.strip
      if last =~ /^-.*/
        plural_form = word.text + last[1, last.length - 1]
      end
      word.assign_attributes :custom_int_field1 => gender_id, :custom_string_field1 => plural_form, :type_id => 2
    end
  end
end