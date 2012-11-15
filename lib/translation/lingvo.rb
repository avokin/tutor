require 'nokogiri'
require 'open-uri'

require "german_lingvo_parser"
require "default_lingvo_parser"

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

    if ENV['RAILS_ENV'] == "test"
      if word.text == "Kind"
        doc = Nokogiri::HTML(IO.read("lib/translation/german_kind.html"))
      else
        doc = Nokogiri::HTML(IO.read("lib/translation/english_parrot.html"))
      end
    else
      doc = Nokogiri::HTML(open("http://lingvopro.abbyyonline.com/ru/Translate/#{@@language_hash[source_language]}-#{@@language_hash[dest_language]}/#{word.text}"))
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
  end
end
