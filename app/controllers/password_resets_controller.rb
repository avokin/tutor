class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to signin_url, :notice => 'Email sent with password reset instructions.'
    else
      redirect_to new_password_reset_path, :flash => {:error => 'Not registered user'}
    end
  end

  def edit
    @user = User.find_by_password_reset_token(params[:id])
    if @user.nil?
      redirect_to signin_path, :flash => {:error => 'Recovery token is incorrect or expired'}
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to signin_path, :alert => 'Password reset token has expired.'
    elsif @user.update_password(user_params[:password], user_params[:password_confirmation])
      redirect_to signin_path, :notice => 'Password has been reset!'
    else
      redirect_to edit_password_reset_path @user.password_reset_token
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
