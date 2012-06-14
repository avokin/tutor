require "spec_helper"

describe UserCategoriesController do
  render_views

  before(:each) do
    @user_word_category = Factory(:user_word_category)
    @category = @user_word_category.user_category
    @user_word = @user_word_category.user_word
    @user = @user_word.user
  end

  describe "GET 'index'" do
    before(:each) do
      test_sign_in(@user)
    end

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
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          delete :destroy, :id => @category.id
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          delete :destroy, :id => @category.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @user
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
  end

  describe "POST 'create'" do
    before(:each) do
      test_sign_in(@user_word.user)
    end

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
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          put :update, :id => @category
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          put :update, :id => @category
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @user
      end

      it "should change name of the category and it's default state" do
        put :update, :id => @category.id, :user_category => {:name => "new category", :is_default => true}, :btn_update => "true"
        @category.reload
        @category.name.should == "new category"
        @category.is_default.should be_true
      end

      it "should redirect to category word list" do
        put :update, :id => @category.id, :user_category => {:name => "new category"}, :btn_update => "true"
        response.should redirect_to user_category_path(@category)
      end
    end
  end

  describe "GET 'show'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          get :show, :id => @category.id
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          get :show, :id => @category.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authrorized access" do
      before(:each) do
        test_sign_in @user
      end

      it "should have right title" do
        get :show, :id => @category.id
        response.should have_selector('title', :content => "Tutor - #{@category.name}")
      end

      it "should display words that correspond to the category" do
        get :show, :id => @category.id
        response.should have_selector('a', :content => @user_word.word.text)
      end

      it "should display the 'Edit' link" do
        get :show, :id => @category.id
        response.should have_selector('a', :content => "Edit")
      end
    end
  end

  describe "GET 'new'" do
    before(:each) do
      test_sign_in @user
    end

    it "should have right title" do
      get :new
      response.should have_selector('title', :content => "Tutor - New category")
      response.should have_selector("li", :class => "active") do |li|
        li.should have_selector('a', :content => "Categories")
      end
    end
  end

  describe "GET 'edit'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          get :edit, :id => @category.id
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          get :edit, :id => @category.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @user
      end

      it "should have right title" do
        get :edit, :id => @category.id
        response.should have_selector('title', :content => "Tutor - Edit category: #{@category.name}")
        response.should have_selector("li", :class => "active") do |li|
          li.should have_selector('a', :content => "Categories")
        end
      end
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

  describe "PUT 'merge'" do
    before(:each) do
      @user_word_category = Factory(:user_word_category)
      @category2 = @user_word_category.user_category
    end

    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          put :merge, :ids => "#{@category.id}, #{@category2.id}"
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          put :merge, :ids => "#{@category.id}, #{@category2.id}"
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @user
      end

      it "should move all words to the first category" do
        words_to_move = @category2.user_words
        put :merge, :ids => "#{@category.id}, #{@category2.id}"

        words_to_move.each do |word|
          word.reload
          word.user_category.first.should == @category
        end
      end

      it "should remove all categories except the first" do
        put :merge, :ids => "#{@category.id}, #{@category2.id}"
        UserCategory.find_by_id(@category2.id).should be_nil
      end
    end
  end
end