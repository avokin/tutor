require 'net/http'
require 'uri'

module TranslationHelper
  START_MARKER = '<span class="translation">'
  END_MARKER = '</span>'

  @@language_hash = Hash.new
  @@language_hash[:en] = "en"
  @@language_hash[:ru] = "ru"
  @@language_hash[:de] = "de"

  def request_lingvo(user, source_language, word, dest_language)
    result = []

    url = URI.parse('http://lingvopro.abbyyonline.com')
    #res = Net::HTTP.start(url.host, url.port) {|http|
    #  http.get("/ru/Translate/#{@@language_hash[source_language]}-#{@@language_hash[dest_language]}/#{word.text}")
    #}

    i = 0
    #s = res.body

    s = START_MARKER + "test" + END_MARKER
    while word.direct_translations.length < 4 do
      i = s.index(START_MARKER, i)
      if !i.nil?
        k = s.index(END_MARKER, i)
        translation = s[i + START_MARKER.length, k - i - START_MARKER.length]
        translation = translation.strip
        if translation == '' || translation == ';' || translation == ',' || translation[0] == '<'
        else

          if !result.include?(translation)
            translation_word = UserWord.new(:text => translation, :user => user, :language => user.language)
            relation = WordRelation.new({:status_id => 1, :user => user, :relation_type => "1", :source_user_word => word, :related_user_word => translation_word})
            word.direct_translations << relation
            result << translation
          end
        end
      else
        break
      end
      i = k + END_MARKER.length
    end
  end
end
