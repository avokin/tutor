class UsersController < ApplicationController
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    user = User.new(params[:user])
    if user.save()
      sign_in(user)
      redirect_to user
    else
      new()
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = "User #{@user.name}"
  end
end