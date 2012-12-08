require 'spec_helper'

describe SearchController, :type => :controller do
  #render_views

  before(:each) do
    init_db
  end

  describe "POST 'create'" do
    before(:each) do
      @new_word = 'new word'
      @user_word = FactoryGirl.create(:english_user_word)
      @another_user_word = FactoryGirl.create(:english_user_word_for_another_user)

      @user = @user_word.user
    end

    describe 'not logged in user search' do
      it 'should redirect to login page' do
        post :create, :search => {:word => @new_word}
        response.should redirect_to signin_path
      end
    end

    describe 'logged in user search' do
      before(:each) do
        test_sign_in(@user)
      end

      it "should create a new word if current user does not contain the word" do
        post :create, :search => {:text => @new_word}
        response.code.should == "302"
        response.should redirect_to(new_user_word_path(:text => @new_word))
      end

      it "should open word's card if current user contains the word" do
        word = @user.user_words.first
        post :create, :search => {:text => word.text}
        response.should redirect_to(user_word_path(@user.user_words.first))
      end

      it "should not find word that belongs to another user" do
        post :create, :search => {:text => @another_user_word.text}
        response.should redirect_to(new_user_word_path(:text => @another_user_word.text))
      end

      describe "searching with several foreign languages" do
        before(:each) do
          @english_word = FactoryGirl.create(:english_user_word)
          @german_word = FactoryGirl.create(:german_user_word)
        end

        it "should not find word of another language" do
          post :create, :search => {:text => @german_word.text}
          response.should redirect_to(new_user_word_path(:text => @german_word.text))
        end
      end
    end
  end

  describe "GET 'autocomplete_word_text'" do
    describe "unauthorized access" do
      it "should redirect to signin page" do
        get :autocomplete_user_word_text
        response.should redirect_to signin_path
      end
    end

    describe "authorized access" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      describe "success" do
        before(:each) do
          @user_word1 = FactoryGirl.create(:english_user_word)
        end

        it "should return correspond words" do
          get :autocomplete_user_word_text, :term => @user_word1.text
          response.body.should =~ /.*#{@user_word1.text}.*/
        end
      end
    end
  end

  describe "GET 'autocomplete_category name'" do
    describe "unauthorized access" do
      it "should redirect to signin page" do
        get :autocomplete_user_category_name
        response.should redirect_to signin_path
      end
    end

    describe "authorized access" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      describe "success" do
        before(:each) do
          @user_category = FactoryGirl.create(:user_category)
        end

        it "should return correspond words" do
          get :autocomplete_user_category_name, :term => @user_category.name
          response.body.should =~ /.*#{@user_category.name}.*/
        end
      end
    end
  end
end