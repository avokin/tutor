module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out()
    cookies.permanent.signed[:remember_token] = [nil, nil]
    self.current_user = nil
  end

  def current_user
    @current_user ||= try_to_authorize
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  private
    def try_to_authorize
      authentication_token = request.headers["HTTP_AUTHORIZATION"]
      if authentication_token != nil
        login_password = authentication_token.split(':')
        User.authenticate *login_password
      else
        User.authenticate_with_salt(*remember_token)
      end
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
