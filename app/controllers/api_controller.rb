class ApiController < ApplicationController
  before_filter :authenticate

  def import
    words = params[:words]

    UserWord.transaction do
      words.each do |word_id, values|
        word = UserWord.find(word_id)

        word.time_to_check = values[:time_to_check]
        word.success_count = values[:success_count]

        word.save!
      end
    end

    render text: 'ok'
  end
end
