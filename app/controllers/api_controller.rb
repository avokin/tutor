class ApiController < ApplicationController
  before_filter :authenticate, except: :word
  include Translation::Multitran
  include UserWordsHelper

  def import
    begin
    UserWord.transaction do
      updated_words = params[:updated_words]
      unless updated_words.nil?
        updated_words.each do |updated_word|
          word = UserWord.find_by_id(updated_word[:id])
          unless word.nil?
            word.success_count = updated_word[:success_count]
            word.time_to_check = updated_word[:time_to_check]
            word.save!
          end
        end
      end
    end
    rescue Exception => e
      puts e
    end
    render text: 'ok'
  end

  def export
    @languages = Language.all
    @user_words = UserWord.where(user_id: current_user.id)
    @word_relations = WordRelation.joins(:source_user_word).where(user_words: { user_id: current_user.id })
    @user_categories = UserCategory.where(user_id: current_user.id)
    @user_word_categories = UserWordCategory.joins(:user_word).where(user_words: { user_id: current_user.id })
  end

  def word
    @word = UserWord.new text: params[:query], language_id: 3
    language = Language.find(1)
    request_translation(@word, language)
  end

  def add_word
    user_word = UserWord.new :user_id => current_user.id
    saved = create_or_update(user_word)
    if saved
      render text: "{\"word_id\": \"#{user_word.id}\"}"
    else
      render text: "{\"error\": \"Can't save\"}"
    end
  end

  private
  def word_params
    permit_params(params)
  end
end
