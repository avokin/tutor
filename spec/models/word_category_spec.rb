require 'spec_helper'

describe UserWordCategory do
  before(:each) do
    init_db
  end

  describe 'create WordCategory' do
    it 'should validate user from category and from word' do
      category = FactoryGirl.create(:user_category, :user => second_user)

      expect do
        FactoryGirl.create(:user_word_category, :user_category => category)
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it 'should validate language from category and from word' do
      category = FactoryGirl.create(:user_category, :language => german_language)

      expect do
        FactoryGirl.create(:user_word_category, :user_category => category)
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
