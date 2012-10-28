class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def destroy
    sign_out()
    redirect_to(root_path)
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash[:error] = 'Invalid email/password'
      @title = 'Sign in'
      redirect_to signin_path
    else
      sign_in user
      redirect_to user
    end
  end
end
