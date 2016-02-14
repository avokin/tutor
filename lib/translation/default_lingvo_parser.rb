class DefaultLingvoParser < BaseParser
  def parse(doc, word)
    processed = Array.new

    i = 0
    doc.css('p.P1 a').each do |link|
      break if i == 4
      translation = link.content
      process_translation translation, word, processed
      i += 1
    end

    dictionary_word = false#DictionaryWord.find_by_word(word.text)
    if dictionary_word
      word.transcription = dictionary_word.transcription
    end
  end
end