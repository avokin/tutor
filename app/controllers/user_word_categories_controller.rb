class UserWordCategoriesController < ApplicationController
  def destroy
    user_word_category = UserWordCategory.find(params[:id])
    if user_word_category.user_word.user != current_user
      render 'pages/message'
      return
    end

    word = user_word_category.user_word
    user_word_category.destroy
    redirect_to word
  end
end
