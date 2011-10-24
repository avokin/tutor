class UsersController < ApplicationController
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save()
      sign_in(@user)
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = "User #{@user.name}"
  end

  def init
    unless current_user.nil?
      init_languages
      redirect_to current_user
    else
      redirect_to root_path
    end
  end

  def edit

  end


  def update
    redirect_to root_path
  end
end