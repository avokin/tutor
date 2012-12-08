require 'nokogiri'
require 'open-uri'

require "german_lingvo_parser"
require "default_lingvo_parser"

include Translation::GermanLanguage

module Translation::Lingvo
  def request_lingvo(language_name, word, dest_language)
    @@language_hash = Hash.new
    @@language_hash[:en] = "en"
    @@language_hash[:ru] = "ru"
    @@language_hash[:de] = "de"

    source_language = case language_name
                        when "Deutsch" then
                          :de
                        else
                          :en
                      end

    preprocessor = LingvoParserFactory.get_word_preprocessor(source_language)
    unless preprocessor.nil?
      preprocessor.process(word)
    end

    if ENV['RAILS_ENV'] == "test"
      if word.text == "Kind"
        doc = Nokogiri::HTML(IO.read("lib/translation/german_kind.html"))
      elsif word.text == "Oma"
        doc = Nokogiri::HTML(IO.read("lib/translation/german_oma.html"))
      elsif word.text =~ /^Getr.*$/
        doc = Nokogiri::HTML(IO.read("lib/translation/german_getraenk.html"))
      else
        doc = Nokogiri::HTML(IO.read("lib/translation/english_parrot.html"))
      end
    else
      encoded_url = URI::encode("http://lingvopro.abbyyonline.com/ru/Translate/#{@@language_hash[source_language]}-#{@@language_hash[dest_language]}/#{word.text}")
      doc = Nokogiri::HTML(open(encoded_url))
    end

    LingvoParserFactory.get_lingvo_parser(source_language).parse(doc, word)
  end

  class LingvoParserFactory
    def self.get_lingvo_parser(source_language)
      case source_language
        when :de then
          GermanLingvoParser.new
        else
          DefaultLingvoParser.new
      end
    end

    def self.get_word_preprocessor(source_language)
      case source_language
        when :de then
          GermanWordPreprocessor.new
        else
          nil
      end
    end
  end
end
