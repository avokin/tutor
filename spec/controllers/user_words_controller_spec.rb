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

    it 'should display word customization' do
      get :new, :text => 'parrot'
      expect(response.body).to have_content('Transcription')
    end

    it 'should have default category of target languages' do
      get :new, :text => 'parrot'
      expect(response.body).to have_content('included')
      expect(response.body).not_to have_content('excluded')
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

  describe "Put 'create'" do
    before(:each) do
      test_sign_in(first_user)
    end

    it 'should create word with correct attributes' do
      lambda do
        put :create, {user: first_user, translation_0: 'tran0', translation_1: 'tran1', synonym_0: 'syn0',
                      category_0: 'cat0', type_id: 1,
                      user_word: {language_id: first_user.target_language.id, text: 'new_word'}}
      end.should change(UserWord, :count)

      word = UserWord.find_by text: 'new_word'
      expect(word.translations.count).to eq(2)
      expect(word.synonyms.count).to eq(1)
      expect(word.user_word_categories.count).to eq(1)
      expect(word.type_id).not_to be(nil)
    end
  end
end
