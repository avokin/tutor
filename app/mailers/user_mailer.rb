class UserMailer < ActionMailer::Base
  default from: "admin@word-tutor.herokuapp.com"

  def password_reset(user)
    @user = user
    @user.password_reset_token = "something"
    mail :to => user.email, :subject => "Password Reset"
  end
end
