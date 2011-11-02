class UserCategoriesController < ApplicationController
  def new
    @title = "New category"
    @category = UserCategory.new
  end

  def create
    @category = UserCategory.new params[:user_category]
    @category.user = current_user

    count = UserCategory.find_by_user_and_name(current_user, @category.name).length
    if count > 0
      render 'pages/message'
    else
      if @category.save
        redirect_to user_categories_path
      else
        render 'pages/message'
      end
    end
  end

  def index
    @title = "Your categories"
    @categories = UserCategory.all
  end

  def edit
    @category = UserCategory.find(params[:id])
    @title = "Edit category: #{@category.name}"
  end

  def update
    @category = UserCategory.find(params[:id])
    if @category.update_attributes(params[:user_category])
      redirect_to user_category_path
    else
      render 'edit'
    end
  end

  def show
    @category = UserCategory.find(params[:id])
  end

  def destroy
    category = UserCategory.find(params[:id])
    if category.user != current_user
      render "pages/message"
      return
    end

    category.destroy
    redirect_to user_categories_path
  end

  def update_defaults
    current_user.user_categories.each do |user_category|
      default = params["id#{user_category.id}"]
      if default.nil?
        default = false
      else
        default = true
      end

      if user_category.is_default != default
        user_category.is_default = default
        user_category.save!
      end
    end

    redirect_to user_categories_path
  end
end