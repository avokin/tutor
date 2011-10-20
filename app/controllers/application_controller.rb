class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  include TranslationHelper

  protected
  def authenticate
    authenticate_user()
  end
end



