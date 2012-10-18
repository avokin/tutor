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
    @title = "User #{current_user.name}"
  end

  def update
    current_user.update_attributes(params[:user])
    current_user.language = Language.find(params[:user][:native_language_id])
    current_user.save
    render "show"
  end
end