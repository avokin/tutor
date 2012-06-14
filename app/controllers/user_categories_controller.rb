class UserCategoriesController < ApplicationController
  before_filter :set_active_tab

  def new
    @title = "New category"
    @category = UserCategory.new
  end

  def create
    @category = UserCategory.new params[:user_category]
    @category.user = current_user

    existed_category = UserCategory.find_by_user_and_name(current_user, @category.name)
    if existed_category.nil?
      if @category.save
        redirect_to user_categories_path
      else
        render 'pages/message'
      end
    else
      render 'pages/message'
    end
  end

  def index
    @title = "Your categories"
    @categories = UserCategory.all
  end

  def edit
    session[:return_to] ||= request.referer
    @category = UserCategory.find(params[:id])
    @title = "Edit category: #{@category.name}"
  end

  def update
    if params[:commit] == "Update"
      @category = UserCategory.find(params[:id])
      if @category.update_attributes(params[:user_category])
        redirect_to user_category_path
      else
        render 'edit'
      end
    else
      redirect_to session[:return_to]
    end
  end

  def show
    @category = UserCategory.find(params[:id])
    @title = @category.name
    @user_words = @category.user_words.paginate(:page => params[:page])
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

  private
  def set_active_tab
    @active_tab = :categories
  end
end