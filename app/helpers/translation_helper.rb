require 'net/http'
require 'uri'

module TranslationHelper
  START_MARKET = '<span class="translation">'
  END_MARKET = '</span>'

  @@language_hash = Hash.new
  @@language_hash[:en] = "en"
  @@language_hash[:ru] = "ru"
  @@language_hash[:de] = "de"

  def request_lingvo(source_language, word, dest_language)
    result = []

    url = URI.parse('http://lingvopro.abbyyonline.com')
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get("/ru/Translate/#{@@language_hash[source_language]}-#{@@language_hash[dest_language]}/#{word.text}")
    }

    i = 0
    s = res.body
    while word.direct_translations.length < 4 do
      i = s.index(START_MARKET, i)
      if !i.nil?
        k = s.index(END_MARKET, i)
        translation = s[i + START_MARKET.length, k - i - START_MARKET.length]
        translation = translation.strip
        if translation == '' || translation == ';' || translation == ',' || translation[0] == '<'
        else
          if !result.include?(translation)
            word.direct_translations << WordRelation.new({:related_user_word => UserWord.new(:text => translation)})
            result << translation
          end
        end
      else
        break
      end
      i = k + END_MARKET.length
    end
  end
end
