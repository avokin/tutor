require 'spec_helper'

describe ApiController, :type => :controller do
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
      request.env['HTTP_AUTHORIZATION'] = @token
    end

    it 'should return all data' do
      get :export, :format => :json

      expect(response.status).to eql(200)
      expect(response.body).to eql('{"languages":[{"id":1,"name":"English"},{"id":2,"name":"Russian"},{"id":3,"name":"Deutsch"}],"words":[{"id":1,"language_id":1,"text":"english1","comment":"","type_id":null,"custom_int_field1":null,"custom_string_field1":null,"time_to_check":"2001-02-03T04:05:06.000Z","success_count":0},{"id":3,"language_id":1,"text":"english2","comment":"","type_id":null,"custom_int_field1":null,"custom_string_field1":null,"time_to_check":"2001-02-03T04:05:06.000Z","success_count":0},{"id":2,"language_id":2,"text":"russian1","comment":null,"type_id":null,"custom_int_field1":null,"custom_string_field1":null,"time_to_check":"2001-02-03T04:05:06.000Z","success_count":0}],"word_relations":[{"id":1,"source_user_word_id":1,"related_user_word_id":2,"relation_type":1}],"categories":[{"id":1,"name":"category 1","is_default":false,"language_id":1}],"word_categories":[{"user_word_id":3,"user_category_id":1}]}')
    end

    describe 'unauthorized access' do
      it 'should return nothing' do
        request.env['HTTP_AUTHORIZATION'] = nil
        get :export, :format => :json

        expect(response.status).to eql(401)
        expect(response.body).to include('Unauthorized')
      end
    end
  end

  describe 'import process' do
    before(:each) do
      FactoryGirl.create(:word_relation_translation)
      FactoryGirl.create(:user_word_category)
      @word_id = UserWord.first.id
      request.env['HTTP_AUTHORIZATION'] = @token
    end

    it 'should update success_count and time_to_check' do
      post :import, updated_words: [{id: @word_id, success_count: 10, time_to_check: DateTime.now}], :format => :json

      word = UserWord.find(@word_id)
      expect(word.success_count).to eql(10)
    end

    describe 'unauthorized access' do
      it 'should return nothing' do
        request.env['HTTP_AUTHORIZATION'] = nil
        post :import, updated_words: [{id: @word_id, success_count: 10, time_to_check: DateTime.now}], :format => :json

        expect(response.status).to eql(401)
        expect(response.body).to include('Unauthorized')

        word = UserWord.find(@word_id)
        expect(word.success_count).to eql(0)
      end
    end
  end

  describe 'word request' do
    it 'should provide word translations and grammar' do
      get :word, query: 'Kind', format: :json

      expect(response.body).to eql("{\n  \"type_id\": 2,\n  \"custom_int_field1\": 4,\n  \"custom_string_field1\": \"-er\",\n  \"translations\": [\n      \"ребёнок\",\n      \"дитя\",\n      \"малыш\",\n  ]\n}")
    end
  end

  describe 'add word' do
    before(:each) do
      request.env['HTTP_AUTHORIZATION'] = @token

      @put_parameters = {translation_0: 'translation_0', synonym_0: 'synonym_0', category_0: 'category_0',
                         user_word: {language_id: @user.target_language.id, text: 'word', type_id: 1,
                                     custom_int_field1: 1, custom_string_field1: 'custom'}}
    end

    it 'should create word' do
      expect do
        put :add_word, format: :json, **@put_parameters
      end.to change(UserWord, :count).by(3)

      word = UserWord.find_by_text('word')

      expect(response.body).to include("#{word.id}")

      expect(word.translations.count).to eq(1)
      expect(word.translations[0].related_user_word.text).to eq('translation_0')

      expect(word.synonyms.count).to eq(1)
      expect(word.synonyms[0].related_user_word.text).to eq('synonym_0')

      expect(word.user_categories.count).to eq(1)
      expect(word.user_categories[0].name).to eq('category_0')
    end

    describe 'unauthorized access' do
      it 'should return error' do
        request.env['HTTP_AUTHORIZATION'] = nil

        expect do
          put :add_word, format: :json, **@put_parameters
        end.not_to change(UserWord, :count)

        expect(response.status).to eql(401)
        expect(response.body).to include('Unauthorized')
      end
    end
  end
end