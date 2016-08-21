class UserWordsController < ApplicationController

  include UserWordsHelper
  include Translation::Multitran

  before_filter :authenticate
  before_filter :set_active_tab
  before_filter :check_user, :except => [:new, :create, :index]

  def new
    @title = 'New word'
    @languages = Language.all
    @user_word = UserWord.new
    @user_word.language = current_user.target_language
    @languages = Language.all

    @user_word.assign_attributes word_params
    @user_word.user = current_user

    request_translation(@user_word, current_user.language)

    @categories = UserCategory.find_all_by_is_default(current_user)
    @user_word_categories = @categories.map {|category| UserWordCategory.new :user_word => @user_word, :user_category => category}
    @user_word.user_word_categories = @user_word_categories

    render 'edit'
  end

  def create
    user_word = UserWord.new :user_id => current_user.id
    create_or_update(user_word)
  end

  def show
    return unless check_user

    @title = "Card for word: #{@user_word.text}"
  end

  def edit
    return unless check_user
    unless word_params[:type_id].nil?
      @user_word.type_id = Integer word_params[:type_id]
    end

    @title = "Edit word: #{@user_word.text}"
  end

  def index
    @user_words = current_user.foreign_user_words.paginate(:page => params[:page])
    @title = 'Your words'
  end

  def update
    return unless check_user
    user_word = UserWord.find params[:id]
    create_or_update(user_word)
  end

  def destroy
    return unless check_user
    UserWord.destroy(@user_word)
    redirect_to root_path
  end

  def recent
    @user_words = UserWord.find_recent_for_user(current_user, 50)
    @title = 'Your recent words'
  end

  private
  def create_or_update(user_word)
    new_translations = Array.new
    word_params['translation_0'].split(';').each do |s|
      unless s.nil?
        translation = s.strip
        if translation.length > 0
          new_translations << translation
        end
      end
    end

    (1..[4, user_word.translations.length].max).each do |i|
      s = word_params["translation_#{i}"]
      if !s.nil? && s.length > 0
        new_translations << s
      end
    end

    i = 0
    new_synonyms = Array.new
    until word_params["synonym_#{i}"].nil? do
      s = word_params["synonym_#{i}"]
      if s.length > 0
        new_synonyms << s
      end
      i = i + 1
    end

    i = 1
    new_categories = Array.new
    until word_params["category_#{i}"].nil? do
      s = word_params["category_#{i}"]
      if s.length > 0 && !new_categories.include?(s)
        new_categories << s
      end
      i = i + 1
    end

    word_params['category_0'].split(',').each do |s|
      s.strip!
      if !s.nil? && s.length > 0 && !new_categories.include?(s)
        new_categories << s
      end
    end

    user_word.user = current_user
    user_word.type_id = word_params[:type_id]
    if word_params[:user_word]
      user_word.assign_attributes(word_params[:user_word])
    end
    saved = user_word.save_with_relations(new_translations, new_synonyms, new_categories)
    @user_word = user_word
    if saved
      redirect_to user_word_path(@user_word), :flash => {:success => 'Word saved'}
    else
      flash.now[:error] = 'error'
      render 'edit'
    end
  end

  private

  def check_user
    @user_word = UserWord.find(params[:id])
    unless @user_word.nil?
      if @user_word.user != current_user
        redirect_to(root_path, :flash => {:error => 'Error another user'}) unless current_user?(@user_word.user)
        return false
      end
    end
    true
  end

  def set_active_tab
    @active_tab = :dictionary
  end

  def word_params
    params.permit(:text, :type_id, :translation_0, :translation_1, :translation_2, :translation_3, :synonym_0,
                  :synonym_1, :synonym_2, :synonym_3, :category_0, :category_1, :category_2, :category_3, :language_id,
                  :user_word => [:language_id, :type_id, :text, :custom_int_field1, :custom_string_field1, :comment])
  end
end
