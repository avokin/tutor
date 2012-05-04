include WordRelationsHelper

class WordRelationsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:destroy, :destroy_with_related_word]

  def create
    user_word_id = params[:word_relation][:user_word_id]
    translated_text = params[:word_relation][:related_word]
    relation_type = params[:word_relation][:relation_type]

    relation = WordRelation.create_relation(current_user, UserWord.find(user_word_id), translated_text, relation_type)
    if relation.nil?
      render 'pages/message'
    else
      if relation.save
        redirect_to relation.source_user_word
      else
        render 'pages/message'
      end
    end
  end

  def destroy
    @word_relation.destroy
    redirect_to @word_relation.source_user_word
  end

  def destroy_with_related_word
    @word_relation.related_user_word.destroy
    redirect_to @word_relation.source_user_word
  end

  private
    def correct_user
      @word_relation = WordRelation.find(params[:id])
      if @word_relation.nil?
        redirect_to(root_path)
      else
        @user = @word_relation.user

        redirect_to(root_path, :flash => { :error => "Error another user" }) unless current_user?(@user)
      end
    end
end