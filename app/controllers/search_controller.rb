class SearchController < ApplicationController
  before_filter :authenticate

  autocomplete :word, :word
  autocomplete :category, :name

  def create
    text = params[:search][:word]
    @user_word = UserWord.find_for_user(current_user, text)
    if !@user_word.nil?
      redirect_to @user_word
    else
      redirect_to new_user_word_path(:word => text)
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
