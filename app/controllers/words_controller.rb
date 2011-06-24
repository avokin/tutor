class WordsController < ApplicationController
  def new
    @title = 'New word'
    @word = Word.new
    @word.word = params[:word] unless params[:word].nil?
  end

  def create
    @word = Word.new params[:word]
    if (@word.save)
      redirect_to @word
    else
      render 'none'
    end
  end

  def show
    @title = 'Word'
    @word = Word.find(params[:id])
    @translation = Translation.new
  end

  def index
    @words = Word.all
  end
end