require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end

  describe "POST 'create'" do
    describe "invalid sign in" do
      before(:each) do
        @attr = {:email => 'test@test.com', :password => 'invalid'}
      end

      it "should re-render 'new' template" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end

      it "should display flash with errors" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "correct sign in" do
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end

      it "should sign a user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to user show page" do
        post :create, :session => @attr
        response.should redirect_to user_path(@user)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it 'should sign a user out' do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
