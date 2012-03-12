require 'spec_helper'

describe TrainingsController do

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
end
