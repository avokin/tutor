class DefaultLingvoParser < BaseParser
  def parse(doc, word)
    processed = Array.new

    doc.css('p.P1 a').each do |link|
      translation = link.content
      process_translation translation, word, processed
    end
  end
end