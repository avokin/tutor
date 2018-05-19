include TrainingsHelper

class TrainingsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user_for_user_word, :only => [:show]
  before_filter :correct_user_training, :only => [:destroy, :start, :learn]
  before_filter :set_active_tab

  def show
    @title = 'Training'
    @active_tab = :training

    training_id = params[:id]
    @training = Training.find(training_id)
    @words = @training.get_ready_user_words
  end

  def learn
    #ToDo remove this method
    cookies.permanent.signed[:training_id] = params[:id]
    cookies.permanent.signed[:page] = params[:page]

    @title = 'Learning'
    @active_tab = :training

    @page = params[:page].to_i

    redirect_to learning_training_path
  end

  def learning
    @title = t('training.learning')
    @active_tab = :training

    @training = Training.find(params[:id])
    @words = @training.get_user_words
  end

  def training_data
    unless params[:word_id].nil?
      word = UserWord.find(params[:word_id])
      if correct_user_for_user_word word
        result = params[:result]
        if result == 'true'
          word.success_attempt
        else
          word.fail_attempt
        end

        word.save!
      end
    end
  end

  def index
    @title = 'Trainings'
    @trainings = Training.where(user_id: current_user.id)
  end

  def new
    @title = 'New Training'
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
          redirect_to trainings_path, :flash => {:success => 'Training created.'}
          return
        end
      end
    end
    #ToDo splash
    #ToDo: fill entered parameters
    redirect_to new_training_path
  end

  def destroy
    if @training.nil?
      redirect_to(trainings_path, :flash => {:error => ANOTHER_USER_ERROR_MESSAGE}) unless current_user?(@user)
    else
      Training.destroy(@training)
      redirect_to trainings_path
    end
  end

  private
  def correct_user_training
    @training = Training.find(params[:id])
    if @training.nil?
      redirect_to(root_path)
    else
      unless current_user == @training.user
        redirect_to(root_path, :flash => {:error => ANOTHER_USER_ERROR_MESSAGE}) unless current_user?(@user)
      end
    end
  end

  def correct_user_for_user_word(user_word = nil)
    if user_word.nil?
      @user_word = UserWord.find(params[:id])
    else
      @user_word = user_word
    end

    if @user_word.nil?
      redirect_to(root_path)
      false
    else
      @user = @user_word.user
      redirect_to(root_path, :flash => {:error => ANOTHER_USER_ERROR_MESSAGE}) unless current_user?(@user)
      false
    end
    true
  end

  def set_active_tab
    @active_tab = :training
  end
end
