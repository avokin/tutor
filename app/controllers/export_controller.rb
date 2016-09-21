class ExportController < ApplicationController
  before_filter :authenticate

  def export
    @languages = Language.all
    @user_words = UserWord.where(user_id: current_user.id)
    @word_relations = WordRelation.joins(:source_user_word).where(user_words: { user_id: current_user.id })
    @user_categories = UserCategory.where(user_id: current_user.id)
    @user_word_categories = UserWordCategory.joins(:user_word).where(user_words: { user_id: current_user.id })
  end
end
