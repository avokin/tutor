class SearchController < ApplicationController
  def create
    text = params[:search][:word]
    @word = Word.find_by_word(text)
    if !@word.nil?
      redirect_to @word
    else
      redirect_to new_word_path(:word => text)
    end
  end
end
