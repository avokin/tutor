class WordRelationsController < ApplicationController
  def create
    @word = Word.find(params[:word_relation][:word_id])
    if (@word.nil?)
      redirect_to 'error'
    end

    translated_text = params[:word_relation][:related_word]
    related_word = Word.find_by_word(translated_text)

    if (related_word.nil?)
      related_word = Word.new
      related_word.language_id = @word.language_id == 1 ? 2 : 1
      related_word.word = translated_text
    end

    relation_type = params[:word_relation][:relation_type]
    case relation_type
      when "1"
        @word_relation = @word.direct_translations.build()
        @word_relation.relation_type = 1
      when "2"
        @word_relation = @word.direct_synonyms.build()
        @word_relation.relation_type = 2
    end

    @word_relation.related_word = related_word
    if (@word_relation.save)
      redirect_to @word
    else
      redirect_to 'pages#error'
    end
  end

  def destroy
    t = WordRelation.find(params[:id])
    t.destroy
    redirect_to t.source_word
  end
end