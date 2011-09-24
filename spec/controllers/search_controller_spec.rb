require 'spec_helper'

describe SearchController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @new_word = 'new word'
      @user_word = Factory(:word)
      @another_user_word = Factory(:word)
      Factory(:user_word)
      Factory(:user_word)
    end

    describe 'not logged in user search' do
      it 'should redirect to login page' do
        post :create, :search => {:word => @new_word}
        response.should redirect_to signin_path
      end
    end

    describe 'logged in user search' do
      before(:each) do
        user = Factory(:user)
        test_sign_in(user)
      end

      it "should create a new word if current user does not contain the word" do
        post :create, :search => {:word => @new_word}
        response.code.should == "302"
        response.should redirect_to(new_word_path(:word => @new_word))
      end

      it "should open word's card if current user contains the word" do
        post :create, :search => @user_word
        response.should redirect_to(word_path(@user_word))
      end

      it "should not find word that belongs to another user" do
        post :create, :search => @another_user_word
        response.should redirect_to(new_word_path(:word => @another_user_word.word))
      end
    end
  end
end