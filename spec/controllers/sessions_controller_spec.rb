require 'spec_helper'

describe SessionsController, :type => :controller do
  #render_views

  before(:each) do
    init_db
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      expect(response).to be_success
    end

    it 'should have right title' do
      get :new
      expect(response.body).to have_title('Tutor - Sign in')
    end
  end

  describe "POST 'create'" do
    describe "invalid sign in" do
      before(:each) do
        @attr = {:email => 'test@test.com', :password => 'invalid'}
      end

      it "should re-render 'new' template" do
        post :create, :session => @attr
        expect(response).to redirect_to signin_path
      end

      it "should display flash with errors" do
        post :create, :session => @attr
        expect(flash.now[:error]).to match /invalid/i
      end
    end

    describe "correct sign in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end

      it "should sign a user in" do
        post :create, :session => @attr
        expect(controller.current_user).to eq @user
        expect(controller).to be_signed_in
      end

      it "should redirect to user show page" do
        post :create, :session => @attr
        expect(response).to redirect_to user_path(@user)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it 'should sign a user out' do
      test_sign_in(FactoryGirl.create(:user))
      delete :destroy
      expect(controller).not_to be_signed_in
      expect(response).to redirect_to(root_path)
    end
  end
end
