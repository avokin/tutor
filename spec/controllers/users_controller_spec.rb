require 'spec_helper'

describe UsersController do
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

  describe "POST ''" do

  end

end
