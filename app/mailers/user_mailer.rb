class UserMailer < ActionMailer::Base
  default from: "admin@word-tutor.herokuapp.com"

  def password_reset(user)
    @user = user
    unless @user.password_reset_token
      @user.password_reset_token = "something"
    end

    mail :to => user.email, :subject => "Password Reset"
  end
end
