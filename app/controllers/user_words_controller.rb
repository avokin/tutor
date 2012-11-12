class UserWordsController < ApplicationController
  include UserWordsHelper

  before_filter :authenticate
  before_filter :set_active_tab

  def new
    @title = "New word"
    @languages = Language.all
    @user_word = UserWord.new
    @user_word.text = params[:word] unless params[:word].nil?
    @user_word.language = current_user.target_language
    @languages = Language.all
    source_language = case current_user.target_language.name
                        when "Deutsch" then :de
                        else :en
                      end

    @user_word.assign_attributes params

    request_lingvo(current_user, source_language, @user_word, :ru)
    @categories = []
    current_user.user_categories.each do |category|
      if category.is_default
        @categories << category.name
      end
    end

    render "edit"
  end

  def create_or_update(user_word)
    i = 0
    new_translations = Array.new
    while !params["translation_#{i}"].nil? do
      s = params["translation_#{i}"]
      if s.length > 0
        new_translations << s
      end
      i = i + 1
    end

    i = 0
    (0..3).each do |i|
      if !params["suggested_translation_#{i}"].nil?
        new_translations << params["suggested_translation_#{i}"]
      end
    end

    i = 0
    new_synonyms = Array.new
    while !params["synonym_#{i}"].nil? do
      s = params["synonym_#{i}"]
      if s.length > 0
        new_synonyms << s
      end
      i = i + 1
    end

    i = 0

    new_categories = Array.new
    while !params["category_#{i}"].nil? do
      s = params["category_#{i}"]
      if s.length > 0
        new_categories << s
      end
      i = i + 1
    end

    user_word.user = current_user
    user_word.assign_attributes(params[:user_word])
    saved = user_word.save_with_relations(new_translations, new_synonyms, new_categories)
    if saved
      @user_word = user_word
      redirect_to user_word_path(@user_word)
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
      @title = "Card for word: #{@user_word.text}"
    end
  end

  def edit
    @user_word = UserWord.find(params[:id])
    if !params[:type_id].nil?
      @user_word.type_id = Integer params[:type_id]
    end

    if @user_word.user != current_user
      render 'pages/message'
    else
      @title = "Edit word: #{@user_word.text}"
    end
  end

  def index
    @user_words = current_user.foreign_user_words.paginate(:page => params[:page])
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

  def recent
    @user_words = UserWord.find_recent_for_user(current_user, 50)
    @title = 'Your recent words'
  end

  private
  def set_active_tab
    @active_tab = :dictionary
  end
end
