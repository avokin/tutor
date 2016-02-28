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
      @word = FactoryGirl.create(:english_user_word)
      @translation = FactoryGirl.create(:word_relation_translation, :source_user_word => @word)
    end

    describe 'not logged in user' do
      it 'should redirect to signing path' do
        post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: ''
        expect(response).to redirect_to signin_path
      end
    end

    describe 'wrong user' do
      before :each do
        test_sign_in(second_user)
      end

      it 'should redirect to the main page and write into log' do
        post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: ''
        expect(response).to redirect_to root_path
      end
    end

    describe 'correct user' do
      before :each do
        test_sign_in(first_user)
      end

      it 'should save checked translations' do
        lambda do
          post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: '',
               translation_1: @word.translations[0].related_user_word.text,
               translation_2: @word.translations[1].related_user_word.text

        end.should_not change(WordRelation, :count)
      end

      it 'should add category' do
        expect do
          post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: 'new_category'
          @word.reload
          expect(@word.user_categories.last.name).to eq('new_category')
        end.to change { UserWordCategory.count }.by(1)
      end

      it 'should add translation' do
        expect do
          post :update, id: @word.id, translation_0: 'new_tran', synonym_0: '', category_0: ''
          @word.reload
          expect(@word.translations.last.related_user_word.text).to eq('new_tran')
        end.to change { WordRelation.count }.by(1)
      end

      it 'should not add duplicated translation' do
        word = @translation.source_user_word
        translation = @translation.related_user_word
        expect do
          post :update, id: word.id, translation_0: translation.text, synonym_0: '', category_0: ''
        end.not_to change { WordRelation.count }

        word = @translation.source_user_word
        translation = @translation.related_user_word
        expect do
          post :update, id: word.id, translation_0: translation.text, synonym_0: '', category_0: ''
        end.not_to change { WordRelation.count }
      end

      it 'should add synonym' do
        expect do
          post :update, id: @word.id, translation_0: '', synonym_0: 'new_sym', category_0: ''
          @word.reload
          expect(@word.synonyms.last.related_user_word.text).to eq('new_sym')
        end.to change { WordRelation.count }.by(1)
      end
    end
  end

  describe "Put 'create'" do
    before(:each) do
      test_sign_in(first_user)
    end

    it 'should create word with correct attributes' do
      lambda do
        put :create, {user: first_user, translation_0: 'tran0', translation_1: 'tran1', synonym_0: 'syn0',
                      category_0: 'cat0',
                      user_word: {language_id: first_user.target_language.id, text: 'new_word', type_id: 1,
                                  custom_int_field1: 1, custom_string_field1: 'custom'}}
      end.should change(UserWord, :count)

      word = UserWord.find_by text: 'new_word'
      expect(word.translations.count).to eq(2)
      expect(word.synonyms.count).to eq(1)
      expect(word.user_word_categories.count).to eq(1)
      expect(word.type_id).not_to be(nil)
      expect(word.custom_int_field1).to eq(1)
      expect(word.custom_string_field1).to eq('custom')
    end
  end
end
