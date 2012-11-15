class SearchController < ApplicationController
  before_filter :authenticate

  autocomplete :user_word, :text
  autocomplete :user_category, :name

  def create
    text = params[:search][:text]
    @user_word = UserWord.find_for_user(current_user, text)
    if !@user_word.nil?
      redirect_to @user_word
    else
      redirect_to new_user_word_path(:text => text)
    end
  end
end
