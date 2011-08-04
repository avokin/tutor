class SearchController < ApplicationController
  autocomplete :word, :word
  autocomplete :category, :name

  def create
    text = params[:word]
    @word = Word.find_by_word(text)
    if !@word.nil?
      redirect_to @word
    else
      redirect_to new_word_path(:word => text)
    end
  end

  def show
    search = params[:word]
    words = Word.all(:conditions => ['word LIKE ?', "%"+search+"%"])
    @words = Array.new
    words.each do |a|
      @words << "#{a.word}"
    end
    render :json => @words.to_json
  end

end
