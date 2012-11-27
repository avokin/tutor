class GermanLingvoParser < DefaultLingvoParser
  include Translation::GermanLanguage

  def parse(doc, word)
    super doc, word

    type_id = 1

    gender = nil
    last = nil
    grammar_content = doc.css("p span.g-article__comment")[0]
    grammar_content_doc = Nokogiri::HTML(grammar_content.to_s)
    grammar_content_doc.css("span span").each do |comment|
      if comment.to_s =~ /(Neutrum|Maskulinum|Femininum)/
        gender = comment.content
        type_id = 2
      elsif comment.to_s =~ /title="[^"]*Verb[^"]*"/
        type_id = 3
      end
      last = comment.content
    end


    word.assign_attributes :type_id => type_id
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
      word.assign_attributes :custom_int_field1 => gender_id, :custom_string_field1 => plural_form
    end
  end
end