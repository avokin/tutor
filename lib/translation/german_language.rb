#Encoding: UTF-8
module Translation::GermanLanguage
  @@german_genders = [["andere", "andere", "andere", 1], ["der", "maskulin", "m", 2], ["die", "femininum", "f", 3], ["das", "neutrum", "n", 4]]
  @@german_parts_of_speech = [["other", 1], ["noun", 2], ["verb", 3]]

  class GermanWordPreprocessor
    def process(word)
      word.text.gsub!("ae", "ä")
      word.text.gsub!("oe", "ö")
      word.text.gsub!("ue", "ü")
      word.text.gsub!("sss", "ß")
    end
  end
end