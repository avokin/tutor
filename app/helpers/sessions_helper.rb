module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
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
      request_object = request
      unless request_object
        request_object = controller.request
      end
      authentication_token = request_object.headers['HTTP_AUTHORIZATION']
      if authentication_token != nil
        User.authenticate_with_token authentication_token
      else
        User.authenticate_with_salt(*remember_token)
      end
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
