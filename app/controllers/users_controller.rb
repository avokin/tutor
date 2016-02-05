class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]

  def new
    @title = "Sign up"
    @user = User.new
  end

  def edit
    @title = "Edit Account"
  end

  def create
    @user = User.new(user_params)
    @user.target_language_id = Language.all[1].id
    if @user.save()
      sign_in(@user)
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def show
    @title = "User #{current_user.name}"
  end

  def update
    current_user.update_attributes(user_params)
    current_user.target_language = Language.find(user_params[:target_language_id])
    current_user.save
    render "show"
  end

  def set_target_language
    current_user.target_language = Language.find(params[:id])
    current_user.save

    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :target_language_id, :success_count, :native_language_id)
  end
end