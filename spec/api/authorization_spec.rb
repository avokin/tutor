require 'spec_helper'

describe SessionsController, :type => :controller do
  before(:each) do
    init_db
  end

  describe 'Successful login' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @attr = {:email => @user.email, :password => @user.password}
    end

    it 'should return authorization token' do
      post :create, :format => :json, :session => @attr

      expect(response.status).to eql(200)
      expect(response.body).to include('token')
    end
  end

  describe 'Failed login' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @attr = {:email => @user.email, :password => 'wrong password'}
    end

    it 'should not login when incorrect password' do
      post :create, :format => :json, :session => @attr

      expect(response.status).to eql(401)
      expect(response.body).to include('Bad credentials')
    end
  end
end