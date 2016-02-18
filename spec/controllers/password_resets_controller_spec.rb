require 'spec_helper'

describe PasswordResetsController, :type => :controller do
  before(:each) do
    init_db
    @user = first_user
    @user.send_password_reset
  end

  describe "PUT 'update'" do
    describe 'provide correct password and confirmation' do
      before(:each) do
        @attr = {password: 'password', password_confirmation: 'password'}

      end

      it 'should successfully reset password' do
        put :update, id: @user.password_reset_token, user: @attr
        expect(first_user.password_reset_token).to be_nil
        expect(response).to redirect_to signin_path
      end
    end
  end
end
