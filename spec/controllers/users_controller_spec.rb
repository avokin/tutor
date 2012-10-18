require 'spec_helper'

describe UsersController do
  render_views

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "shouldn't create user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)

        response.should render_template('new')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = {:name => 'test', :email => 'test@test.com', :password => 'simple', :password_confirmation => 'simple'}
      end

      it 'should create user' do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      @attributes = {:native_language_id => 3, :success_count => 10}
      test_sign_in(@user)
    end

    it "should have right title" do
      get :edit, :id => @user.id
      response.should have_selector('title', :content => "Tutor - Edit user settings")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      @attributes = {:success_count => 10, :native_language_id => 3}
    end

    describe "Authorized user can edit it's own settings" do
      before(:each) do
        test_sign_in @user
      end

      it "should change Users attributes" do
        put :update, :id => @user.id, :user => @attributes
        @user.reload
        @user.success_count.should == @attributes[:success_count]
        @user.native_language_id.should == @attributes[:native_language_id]
      end
    end

    describe "Not authorized user can't edit settings" do
      it "should not change user's attributes" do
        put :update, :id => @user.id, :user => @attributes
        response.should render_template "pages/message"

        success_count = @user.success_count
        native_language_id = @user.native_language_id
        @user.reload
        @user.success_count.should == success_count
        @user.native_language_id.should == native_language_id
      end
    end
  end
end
