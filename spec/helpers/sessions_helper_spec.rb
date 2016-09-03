require 'spec_helper'

describe SessionsHelper, :type => :helper do
  before(:each) do
    init_db
  end

  describe 'Authorization' do
    it 'should authorize with token' do
      controller.request.headers['HTTP_AUTHORIZATION'] = first_user.encrypted_password
      user = try_to_authorize
      expect(user).not_to be_nil
    end
  end
end