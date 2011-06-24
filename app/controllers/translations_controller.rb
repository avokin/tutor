class TranslationsController < ApplicationController
  def create
    @word = Word.find(params[:translation][:word_id])
    if (@word.nil?)
      redirect_to 'error'
    end

    translated_text = params[:translation][:translated_word]
    translated_word = Word.find_by_word(translated_text)

    if (translated_word.nil?)
      translated_word = Word.new
      translated_word.language_id = @word.language_id == 1 ? 2 : 1
      translated_word.word = translated_text
    end

    @translation = @word.direct_translations.build()
    @translation.translated_word = translated_word
    if (@translation.save)
      redirect_to @word
    else
      render 'none'
    end
  end

  def destroy
    t = Translation.find(params[:id])
    t.destroy
    redirect_to t.source_word
  end
end