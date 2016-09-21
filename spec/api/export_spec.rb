require 'spec_helper'

describe ExportController, :type => :controller do
  before(:each) do
    init_db
    @user = first_user

    @env = Hash.new
    @token = first_user.encrypted_password
  end

  describe 'export process' do
    before(:each) do
      FactoryGirl.create(:word_relation_translation)
      FactoryGirl.create(:user_word_category)
    end

    it 'should return all data' do
      request.env["HTTP_AUTHORIZATION"] = @token
      get :export, :format => :json

      expect(response.status).to eql(200)
      expect(response.body).to eql('[{"id":1,"name":"English"},{"id":2,"name":"Russian"},{"id":3,"name":"Deutsch"},{"id":1,"language_id":1,"text":"english1","comment":null,"type_id":null,"custom_int_field1":null,"custom_string_field1":null},{"id":3,"language_id":1,"text":"english2","comment":null,"type_id":null,"custom_int_field1":null,"custom_string_field1":null},{"id":2,"language_id":2,"text":"russian1","comment":null,"type_id":null,"custom_int_field1":null,"custom_string_field1":null},{"id":1,"name":"category 1","is_default":false,"language_id":1}]')
    end
  end

  describe 'unauthorized access' do
    it 'should return nothing' do
      get :export, :format => :json

      expect(response.status).to eql(401)
      expect(response.body).to include('Unauthorized')
    end
  end
end