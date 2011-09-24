class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

  protected
  def authenticate
    authenticate_user()
  end
end



