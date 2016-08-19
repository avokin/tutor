require 'nokogiri'
require 'open-uri'

require 'german_multitran_parser'

include Translation::GermanLanguage

module Translation::Multitran
  LANGUAGE_HASH = Hash.new
  LANGUAGE_HASH[1] = '3'
  LANGUAGE_HASH[2] = '1'
  LANGUAGE_HASH[3] = '2'

  def get_lingvo_url(word, dest_language)
    URI::encode("http://lingvolive.ru/translate/#{word.language.short_name}-#{dest_language.short_name}/#{word.text}")
  end

  def get_translation_url(word, dest_language)
    url = "http://www.multitran.ru/c/m.exe?l1=#{LANGUAGE_HASH[dest_language.id]}&l2=#{LANGUAGE_HASH[word.language.id]}&s=#{word.text}"
    URI::encode(url)
  end

  def request_translation(word, dest_language)
    # Todo: move to test translator
    if ENV['RAILS_ENV'] == "test"
      if word.text == "Kind"
        doc = Nokogiri::HTML(IO.read("lib/translation/german_kind.html"))
      elsif word.text == "Oma"
        doc = Nokogiri::HTML(IO.read("lib/translation/german_oma.html"))
      elsif word.text =~ /^Getr.*$/
        doc = Nokogiri::HTML(IO.read("lib/translation/german_getraenk.html"))
      else
        doc = Nokogiri::HTML(IO.read("lib/translation/german_papagei.html", encoding: 'windows-1251'))
      end
    else
      encoded_url = get_translation_url(word, dest_language)
      doc = Nokogiri::HTML(open(encoded_url))
    end

    MultitranParserFactory.get_parser(word).parse(doc, word)
  end

  class MultitranParserFactory
    def self.get_parser(word)
      if word.language.is_german
        GermanMultitranParser.new
      else
        nil
      end
    end
  end
end
