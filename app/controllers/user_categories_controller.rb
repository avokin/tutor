class UserCategoriesController < ApplicationController
  before_filter :set_active_tab
  before_filter :authenticate
  before_filter :correct_user, :except => [:new, :index, :create, :merge]

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
    session[:return_to] = request.referer
    @title = "Edit category: #{@category.name}"
  end

  def update
    if params[:btn_cancel].nil?
      if @category.update_attributes(params[:user_category])
        redirect_to session[:return_to] || user_category_path
      else
        render 'edit'
      end
    else
      redirect_to session[:return_to] || user_category_path
    end
  end

  def show
    @title = @category.name
    @user_words = @category.user_words.paginate(:page => params[:page])
  end

  def destroy
    @category.destroy
    redirect_to user_categories_path
  end

  def merge
    category_list = Array.new
    first = nil
    params[:ids].split.each do |s|
      category = UserCategory.find(s.to_i)
      if category.user == current_user
        if first.nil?
          first = category
        else
          category_list << category
        end
      else
        #todo log hack attempt
        redirect_to(root_path, :flash => {:error => "Error another user"}) unless current_user?(@user)
        return
      end
    end

    category_list.each do |category|
      UserWordCategory.update_all( {:user_category_id => first.id}, {:user_category_id => category.id} )
      category.destroy
    end

    render :nothing => true
  end

  private
  def set_active_tab
    @active_tab = :categories
  end

  def correct_user
    @category = UserCategory.find(params[:id])
    if @category.nil?
      redirect_to(root_path)
    else
      @user = @category.user

      redirect_to(root_path, :flash => {:error => "Error another user"}) unless current_user?(@user)
    end
  end
end