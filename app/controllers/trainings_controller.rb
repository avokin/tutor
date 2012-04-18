include TrainingsHelper

class TrainingsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:check, :show]
  before_filter :set_active_tab

  def check
    if !params[:skip].nil?
      skip(@user_word)
      ok = true
    else
      i = 0
      @variants = Array.new
      until (s = params["variant_#{i}"]).nil? do
        @variants << s
        i = i + 1
      end

      @answer_statuses = Hash.new
      ok = check_answers(@user_word, @variants, @answer_statuses)
      unless params[:do_not_remember].nil?
        fail_word(@user_word)
      end
      @answer_classes = Hash.new
      @variants.each do |v|
        @answer_classes[v] = @answer_statuses[v] ? "control-group success" : "control-group error"
      end
    end

    if ok
      training = Training.find cookies.signed[:training_id]
      @user_word = select_user_word(training)
      if @user_word.nil?
        redirect_to trainings_path, :flash => {:success => "There is no ready words in the current training. Have a rest or choose another training."}
      else
        redirect_to training_path(@user_word.id)
      end
    else
      @title = "Training"
      @active_tab = :training
      @show_answer = true

      render :show
    end
  end

  def start
    id = params[:id]
    unless id.nil?
      training = Training.find(params[:id])
      if training.user == current_user
        cookies.permanent.signed[:training_id] = training.id
      else
        redirect_to root_path, :flash => {:error => ANOTHER_USER_ERROR_MESSAGE}
        return
      end
      @user_word = select_user_word(training)
    end

    redirect_to training_path(@user_word.id)
  end

  def show
    @title = "Training"
    @active_tab = :training

    @variants = Array.new(@user_word.direct_translations.length)
    @answer_classes = Hash[nil => ""]
  end

  def index
    @title = "Trainings"
    @trainings = Training.find_all_by_user_id(current_user.id)
  end

  def new
    @title = "New Training"
    @active_tab = :training

    @training = Training.new
  end

  def create
    attrs = params[:training]
    unless attrs.nil?
      unless attrs[:user_category].nil?
        @user_category = UserCategory.find(attrs[:user_category])
      end

      unless attrs[:direction].nil?
        training = Training.new :direction => attrs[:direction].to_sym, :user_category => @user_category
        training.user = current_user
        if training.valid?
          training.save!
          redirect_to trainings_path, :flash => {:success => "Training created."}
          return
        end
      end
    end
    #ToDo splash
    #ToDo: fill entered parameters
    redirect_to new_training_path
  end

  private
  def correct_user
    @user_word = UserWord.find(params[:id])
    if @user_word.nil?
      redirect_to(root_path)
    else
      @user = @user_word.user

      redirect_to(root_path, :flash => {:error => ANOTHER_USER_ERROR_MESSAGE}) unless current_user?(@user)
    end
  end

  def set_active_tab
    @active_tab = :training
  end
end
