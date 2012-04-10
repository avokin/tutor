require 'spec_helper'

describe TrainingsController do
  render_views

  describe "POST 'check'" do
    before(:each) do
      @translation = Factory(:word_relation_translation)
      @user_word = @translation.source_user_word
    end

    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          post :check, :id => @user_word.id
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          post :check, :id => @user_word.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      describe "successful attempt" do
        describe "one word translation" do
          before(:each) do
            test_sign_in @user_word.user
          end

          it "should immediately redirect to the next training page" do
            post :check, :id => @user_word.id, :variant_0 => @translation.related_user_word.word.text
            response.location.should =~ /#{training_path(:id => nil)}\/\d$/
          end
        end

        describe "two word translation" do
          before(:each) do
            @translation2 = Factory(:word_relation_translation, :source_user_word => @user_word)
            test_sign_in @user_word.user
          end

          it "should immediately redirect to the next training page" do
            post :check, :id => @user_word.id, :variant_0 => @translation.related_user_word.word.text, :variant_1 => @translation2.related_user_word.word.text
            response.location.should =~ /#{training_path(:id => nil)}\/\d$/
          end
        end
      end

      describe "unsuccessful attempt" do
        before(:each) do
          test_sign_in @user_word.user
        end

        it "should display correct answer" do
          post :check, :id => @user_word.id, :variant_0 => ""
          response.should render_template 'show'
        end
      end
    end
  end

  describe "POST 'start'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          post :start
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          @user_category = Factory(:user_category)
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          post :start, :scope => @user_category.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      it "should set cookie for mode" do
        post :start, :mode => :trainings
        post :start, :mode => :repetition
      end

      it "should set cookie for scope" do
        post :start, :scope => @user_category.id
        post :start, :scope => nil
      end

      it "should set cookie for direction" do
        post :start, :direction => :foreign_native
        post :start, :direction => :native_foreign
      end

      it "should set cookie for type" do
        post :start, :type => :translation
        post :start, :type => :synonym
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @word_relation = Factory(:word_relation_translation)
      @user_word = @word_relation.source_user_word
    end

    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          get :show, :id => @user_word.id
          response.should redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = Factory(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          get :show, :id => @user_word.id
          response.should redirect_to root_path
          flash[:error].should =~ /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @user_word.user
      end

      it "should show word training page" do
        get :show, :id => @user_word.id
      end
    end
  end

  describe "GET 'index'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          get :index
          response.should redirect_to signin_path
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        @training = Factory(:training)
        @user = @training.user

        @another_user = Factory(:user)
        @user_category = Factory(:user_category, :user => @another_user)
        @training_of_another_user = Factory(:training, :user_category => @user_category, :user => @another_user)

        test_sign_in @user
      end

      it "should display all trainings of current user" do
        get :index
        response.should have_selector("td", :content => @training.user_category.name)
        response.should_not have_selector("td", :content => @user_category.name)
      end
    end
  end

  describe "GET 'new'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          get :new
          response.should redirect_to signin_path
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in @user
      end

      it "should display all trainings of current user" do
        get :new
        response.should have_selector("title", :content => "New Training")

        response.should have_selector('a', :content => "Training", :href => trainings_path)

        response.should have_selector("li", :class => "active") do |li|
          li.should have_selector('a', :content => "Training")
        end
      end
    end
  end

  describe "POST 'create'" do
    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          post :create
          response.should redirect_to signin_path
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in @user
      end

      describe "success" do
        before(:each) do
          @user_category = Factory(:user_category)
          @attr = {:user_category_id => @user_category.id, :direction => :direct}
        end

        it "should create a new Training and redirect to Training index" do
          lambda do
            post :create, :training => @attr
          end.should change(Training, :count).by(1)
          response.should redirect_to trainings_path
        end
      end

      describe "failure" do
        describe "training already exists" do
          before(:each) do
            @training = Factory(:training)
            @attr = {:user_category_id => @training.user_category.id, :direction => :direct}
          end

          it "should not create a new Training and redirect to new page" do
            lambda do
              post :create, :training => @attr
            end.should_not change(Training, :count)

            response.should redirect_to new_training_path
          end
        end

        describe "not provided direction" do
          before(:each) do
            @attr = {}
          end

          it "should not create a new Training and redirect to new page" do
            lambda do
              post :create, :training => @attr
            end.should_not change(Training, :count)

            response.should redirect_to new_training_path
          end
        end

        describe "user_category belongs to another user" do
          before(:each) do
            another_user = Factory(:user)
            another_user_category = Factory(:user_category, :user => another_user)
            @attr = {:user_category_id => another_user_category.id, :direction => :direct}
          end

          it "should not create a new Training and redirect to new page" do
            lambda do
              post :create, :training => @attr
            end.should_not change(Training, :count)

            response.should redirect_to new_training_path
          end
        end

      end
    end
  end
end
