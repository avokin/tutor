module Translation::GermanLanguage
  GERMAN_GENDERS = [['', 'andere', '', 1], ['der', 'maskulin', 'm', 2], ['die', 'femininum', 'f', 3], ['das', 'neutrum', 'n', 4]]
  GERMAN_PART_OF_SPEECH = [['other', 1], ['noun', 2], ['verb', 3]]

  def get_gender_id(text)
    GERMAN_GENDERS.each do |record|
      if record[1] == text || record[2] == text
        return record[3]
      end
    end
    1
  end
end