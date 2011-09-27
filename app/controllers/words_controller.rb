class WordsController < ApplicationController
  before_filter :authenticate

  def new
    @title = "New word: #{params[:word]}"
    @languages = Language.all
    @word = Word.new
    @word.word = params[:word] unless params[:word].nil?
  end

  def create_or_update()
    i = 0
    new_translations = Array.new
    while !params["translation_#{i}"].nil? do
      new_translations << params["translation_#{i}"]
      i = i + 1
    end

    i = 0
    new_synonyms = Array.new
    while !params["synonym_#{i}"].nil? do
      new_synonyms << params["synonym_#{i}"]
      i = i + 1
    end

    i = 0
    new_categories = Array.new
    while !params["category_#{i}"].nil? do
      new_categories << params["category_#{i}"]
      i = i + 1
    end

    if @word.save_with_children(new_translations, new_synonyms, new_categories)
      redirect_to @word
    else
      render 'pages/message'
    end
  end

  def create
    @word = Word.new params[:word]
    create_or_update()
  end

  def show
    @word = Word.find(params[:id])
    @title = "Card for word: #{@word.word}"
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
    @word = Word.find params[:id]
    @word.word = params[:word][:word] unless @word.nil?
    create_or_update()
  end
end