class ExportController < ApplicationController
  before_filter :authenticate

  def export
    begin
    UserWord.transaction do
      updated_words = params[:updated_words]
      unless updated_words.nil?
        updated_words.each do |updated_word|
          word = UserWord.find_by_id(updated_word[:id])
          unless word.nil?
            word.success_count = updated_word[:success_count]
            word.save!
          end
        end
      end
    end
    rescue Exception => e
      puts e
    end

    @languages = Language.all
    @user_words = UserWord.where(user_id: current_user.id)
    @word_relations = WordRelation.joins(:source_user_word).where(user_words: { user_id: current_user.id })
    @user_categories = UserCategory.where(user_id: current_user.id)
    @user_word_categories = UserWordCategory.joins(:user_word).where(user_words: { user_id: current_user.id })
  end
end
