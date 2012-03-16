include TrainingsHelper

class TrainingsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:check, :show]
  before_filter :set_active_tab

  def check
    i = 0
    @variants = Array.new
    until (s = params["variant_#{i}"]).nil? do
      @variants << s
      i = i + 1
    end

    @answer_statuses = Hash.new
    ok = check_answers(@user_word, @variants, @answer_statuses)

    @answer_classes = Hash.new
    @variants.each do |v|
      @answer_classes[v] = @answer_statuses[v] ? "control-group success" : "control-group error"
    end

    if ok
      @user_word = select_user_word(current_user, nil, nil, :foreign_native, nil)
      redirect_to training_path(@user_word.id)
    else
      render :show
    end
  end

  def start
    @user_word = select_user_word(current_user, nil, nil, :foreign_native, nil)
    redirect_to training_path(@user_word.id)
  end

  def show
    @variants = Array.new(@user_word.direct_translations.length)
    @answer_classes = Hash[nil => ""]
  end

  def index
    @user_word = select_user_word(current_user, nil, :foreign_native, :translation, nil)
    redirect_to training_path(@user_word.id)
  end

  private
  def correct_user
    @user_word = UserWord.find(params[:id])
    if @user_word.nil?
      redirect_to(root_path)
    else
      @user = @user_word.user

      redirect_to(root_path, :flash => {:error => "Error another user"}) unless current_user?(@user)
    end
  end

  def set_active_tab
    @active_tab = :training
  end
end
