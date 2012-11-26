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
  end
end