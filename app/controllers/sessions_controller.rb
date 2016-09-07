class SessionsController < ApplicationController
  def new
    @title = 'Sign in'
  end

  def destroy
    sign_out
    redirect_to(root_path)
  end

  def create
    user = User.authenticate_with_email_and_password(params[:session][:email], params[:session][:password])
    respond_to do |format|
      format.html do
        if user.nil?
          flash[:error] = 'Invalid email/password'
          @title = 'Sign in'
          redirect_to signin_path
        else
          sign_in user
          redirect_to user
        end
      end
      format.json {
        if user.nil?
          render json: '{"error": "Bad credentials"}', status: 401
        else
          render json: "{\"token\": \"#{user.encrypted_password}\"}"
        end
      }
    end
  end
end
