class ExportController < ApplicationController
  before_filter :authenticate

  def export
    @languages = Language.all
    @user_words = UserWord.where(user_id: current_user.id)

    @user_categories = UserCategory.where(user_id: current_user.id)
  end
end
