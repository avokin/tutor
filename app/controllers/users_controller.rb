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
    current_user.target_language = Language.find(params[:user][:target_language_id])
    current_user.save
    render "show"
  end
end