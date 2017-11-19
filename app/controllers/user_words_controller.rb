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

    if @user_word.text != nil
      request_translation(@user_word, current_user.language)
    end

    @categories = UserCategory.find_all_by_is_default(current_user)
    @user_word_categories = @categories.map {|category| UserWordCategory.new :user_word => @user_word, :user_category => category}
    @user_word.user_word_categories = @user_word_categories

    render 'edit'
  end

  def create
    user_word = UserWord.new :user_id => current_user.id
    saved = create_or_update(user_word)
    process_save(saved, user_word)
  end

  def show
    return unless check_user
    @user_word.request_count += 1
    @user_word.save!

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
    saved = create_or_update(user_word)
    process_save(saved, user_word)
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

  def process_save(success_save, user_word)
    @user_word = user_word
    if success_save
      redirect_to user_word_path(@user_word), :flash => {:success => 'Word saved'}
    else
      flash.now[:error] = 'error'
      render 'edit'
    end
  end

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
    permit_params(params)
  end
end
