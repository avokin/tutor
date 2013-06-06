require 'spec_helper'

describe UserWordsController, :type => :controller do
  before(:each) do
    init_db
  end

  describe "GET 'new'" do
    before(:each) do
      test_sign_in(first_user)
      FactoryGirl.create(:user_category, :name => "included", :is_default => true)
      FactoryGirl.create(:user_category, :name => "excluded", :is_default => true, :language => german_language)
    end

    it "should have right title" do
      get :new, :text => "parrot"
      response.should have_selector('title', :content => "Tutor - New word")
    end

    it "should have default category of target languages" do
      get :new, :text => "parrot"
      response.should contain("included")
      response.should_not contain("excluded")
    end
  end

  describe 'POST "update"' do
    before :each do
      @word = FactoryGirl.create(:word_relation_translation).source_user_word
      FactoryGirl.create(:word_relation_translation, :source_user_word => @word)
    end

    it 'should save checked translations' do
      lambda do
        post :update, :id => @word.id
      end.should_not change(WordRelation, :count)
    end
  end
end
