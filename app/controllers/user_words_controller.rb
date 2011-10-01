class UserWordsController < ApplicationController
  before_filter :authenticate

  def new
    @title = "New word"
    @languages = Language.all
    @user_word = UserWord.new
    @user_word.word = Word.new
    @user_word.word.text = params[:word] unless params[:word].nil?
    @languages = Language.all
  end

  def create_or_update(user_word)
    text = params[:word][:text] unless params[:word].nil?
    i = 0
    new_translations = Array.new
    while !params["translation_#{i}"].nil? do
      new_translations << params["translation_#{i}"]
      i = i + 1
    end

    i = 0
    new_synonyms = Array.new
    while !params["synonym_#{i}"].nil? do
      new_synonyms << params["synonym_#{i}"]
      i = i + 1
    end

    i = 0
    new_categories = Array.new
    while !params["category_#{i}"].nil? do
      new_categories << params["category_#{i}"]
      i = i + 1
    end

    @user_word = UserWord.save_with_relations(current_user, user_word, text, new_translations, new_synonyms, new_categories);
    if !@user_word.nil?
      redirect_to @user_word
    else
      render 'pages/message'
    end
  end

  def create
    user_word = UserWord.new :user_id => current_user.id
    create_or_update(user_word)
  end

  def show
    @user_word = UserWord.find(params[:id])
    if (@user_word.user != current_user)
      render 'pages/message'
    else
      @title = "Card for word: #{@user_word.word.text}"
    end
  end

  def edit
    @user_word = UserWord.find(params[:id])
    if (@user_word.user != current_user)
      render 'pages/message'
    else
      @title = "Edit word: #{@user_word.word.text}"
    end
  end

  def index
    @user_words = current_user.user_words
    @title = "Your words"
  end

  def update
    user_word = UserWord.find params[:id]
    create_or_update(user_word)
  end

  def destroy
    @user_word = UserWord.find(params[:id])
    if (!@user_word.nil?)
      if (@user_word.user != current_user)
        render 'pages/message'
        return
      end
      UserWord.destroy(@user_word)
      redirect_to root_path
    end
  end
end
