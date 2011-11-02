require "spec_helper"

describe UserCategoriesController do
  render_views

  before(:each) do
    @user_word_category = Factory(:user_word_category)
    @category = @user_word_category.user_category
    @user_word = @user_word_category.user_word

    test_sign_in(@user_word.user)
  end

  describe "GET 'index'" do
    it "should have right title" do
      get :index
      response.should have_selector('title', :content => "Tutor - Your categories")
    end

    it "should display user_categories" do
      get :index
      response.should have_selector('a', :content => "#{@category.name}")
    end
  end

  describe "DELETE 'destroy'" do
    it "should redirect to error page if unauthorized access" do
      another_user = Factory(:user)
      test_sign_in(another_user)
      delete :destroy, :id => @category.id
      response.should render_template "pages/message"
    end

    it "should remove UserCategory record and all depending records" do
      lambda do
        lambda do
          delete :destroy, :id => @category.id
        end.should change(UserCategory, :count).by(-1)
      end.should change(UserWordCategory, :count).by(-1)
    end

    it "should redirect to root path" do
      delete :destroy, :id => @category.id
      response.should redirect_to user_categories_path
    end
  end

  describe "POST 'create'" do
    describe "creation a new Category" do
      it "should create new UserCategory record" do
        lambda do
          post :create, :user_category => {:name => "new category"}
        end.should change(UserCategory, :count).by(1)
      end

      it "should redirect to word list" do
        post :create, :user_category => {:name => "new category"}
        response.should redirect_to user_categories_path
      end
    end

    describe "creation a new Category with already used name" do
      it "shouldn't create new Category" do
        lambda do
          post :create, :user_category => {:name => @category.name}
        end.should_not change(UserCategory, :count)
      end

      it "should redirect to error page" do
        post :create, :user_category => {:name => @category.name}
        response.should render_template("pages/message")
      end
    end
  end

  describe "PUT 'update'" do
    it "should change name of the category" do
      put :update, :id => @category.id, :user_category => {:name => "new category"}
      @category.reload
      @category.name.should == "new category"
    end

    it "should redirect to category word list" do
      put :update, :id => @category.id, :user_category => {:name => "new category"}
      response.should redirect_to user_category_path(@category)
    end
  end

  describe "GET 'show'" do
    it "should display words that corresponds to the category" do
      get :show, :id => @category.id
      response.should have_selector('a', :content => @user_word.word.text)
    end
  end

  describe "PUT 'update_defaults'" do
    before(:each) do
      @user_category1 = Factory(:user_category)
      @user_category2 = Factory(:user_category)
      Factory(:user_word_category)
      user_word = @user_word_category.user_word
      test_sign_in(user_word.user)
    end

    it "should update 'is_default' attribute to all selected categories" do
      put :update_defaults, "id#{@user_category1.id}" => true, "id#{@user_category2.id}" => true

      @user_category1.reload
      @user_category1.is_default.should be_true
      @user_category2.reload
      @user_category2.is_default.should be_true

      put :update_defaults, "id#{@user_category1.id}" => true

      @user_category1.reload
      @user_category1.is_default.should be_true
      @user_category2.reload
      @user_category2.is_default.should be_false
    end
  end
end