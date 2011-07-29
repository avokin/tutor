class WordsController < ApplicationController
  def new
    @title = "New word: #{params[:word]}"
    @languages = Language.all
    @word = Word.new
    @word.word = params[:word] unless params[:word].nil?
  end

  def create
    @word = Word.new params[:word]
    if @word.create_with_translations_and_categories(params)
      redirect_to @word
    else
      render 'pages/message'
    end
  end

  def show
    @word = Word.find(params[:id])
    @title = "Card for word: #{@word.word}"
    @word_relation = WordRelation.new
  end

  def edit
    @word = Word.find(params[:id])
    @title = "Edit word: #{@word.word}"
  end

  def index
    @title = "List of all words"
    @words = Word.all
  end

  def update
    @word = Word.find(params[:id])
    if @word.update_attributes(params[:word])
      redirect_to @word
    else
      render 'edit'
    end
  end
end