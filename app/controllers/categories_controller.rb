class CategoriesController < ApplicationController
  def new
    @title = "New category"
    @category = Category.new
  end

  def create
    @category = Category.new params[:category]
    if @category.save
      redirect_to categories_path
    else
      render 'pages/message'
    end
  end

  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
    @title = "Edit category: #{@category.name}"
  end

  def update
    @category = Word.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to category_path
    else
      render 'edit'
    end
  end

  def show
    @category = Category.find(params[:id])
  end

 def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to category_path
  end
end