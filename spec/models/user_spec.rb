require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => 'test', :email => 'test@test.com', :password => 'password'}
  end
  describe 'Password encryption' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should set encrypted password' do
      @user.encrypted_password.should_not be_blank
    end

    describe 'has_password? method' do
      it 'should accept valid password' do
        @user.has_password?(@attr[:password]).should be_true
      end

      it 'should decline invalid password' do
        @user.has_password?('invalid').should be_false
      end
    end

    describe 'authenticate method' do
      it 'should authenticate user' do
        User.authenticate(@attr[:email], @attr[:password]).should_not be_nil
      end

      it 'should decline user' do
        User.authenticate(@attr[:email], 'invalid').should be_nil
      end
    end

    describe 'authenticate_with_salt method' do
      it 'should authenticate user' do
        User.authenticate_with_salt(@user.id, @user.salt).should_not be_nil
      end

      it 'should decline user' do
        User.authenticate(@attr[:id], 'invalid').should be_nil
      end
    end
  end
end
