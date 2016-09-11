require 'spec_helper'

describe UserWordsController, :type => :controller do
  before(:each) do
    init_db
  end

  describe "GET 'new'" do
    before(:each) do
      test_sign_in(first_user(german_language))
      FactoryGirl.create(:user_category, :name => "included", :is_default => true, :language => german_language)
      FactoryGirl.create(:user_category, :name => "excluded", :is_default => true, :language => english_language)
      FactoryGirl.create(:user_category, :name => "another excluded", :is_default => false, :language => german_language)
    end

    it 'should not fail' do
      get :new, :text => 'Papagei'
    end

    it 'should have default category of target languages' do
      get :new, :text => 'Papagei'
      expect(response.body).to have_content('included')
      expect(response.body).not_to have_content('excluded')
      expect(response.body).not_to have_content('another excluded')
    end
  end

  describe 'POST "update"' do
    before :each do
      @word = FactoryGirl.create(:english_user_word)
      @translation = FactoryGirl.create(:word_relation_translation, :source_user_word => @word)
      FactoryGirl.create(:word_relation_translation, :source_user_word => @word)
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

        @post_arguments = {id: @word.id, translation_0: '', synonym_0: '', category_0: '',
                           translation_1: @word.translations[0].related_user_word.text,
                           translation_2: @word.translations[1].related_user_word.text}
      end

      it 'should save checked translations' do
        expect do
          post :update, @post_arguments
        end.to_not change(WordRelation, :count)
      end

      it 'should add category' do
        expect do
          post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: 'new_category'
          @word.reload
          expect(@word.user_categories.last.name).to eq('new_category')
        end.to change { UserWordCategory.count }.by(1)

        expect do
          post :update, id: @word.id, translation_0: '', synonym_0: '', category_0: 'another_category'
          @word.reload
          expect(@word.user_categories.last.name).to eq('another_category')
        end.to change { UserWordCategory.count }.by(1)
      end

      it 'should add translation' do
        expect do
          post :update, @post_arguments.merge(translation_0: 'new_tran')
          @word.reload
          expect(@word.translations.last.related_user_word.text).to eq('new_tran')
        end.to change { WordRelation.count }.by(1)
      end

      it 'should not add duplicated translation' do
        translation = @translation.related_user_word
        expect do
          post :update, @post_arguments.merge(translation_0: translation.text)
        end.not_to change { WordRelation.count }
      end

      it 'should add synonym' do
        expect do
          post :update, @post_arguments.merge(synonym_0: 'new_sym')
          @word.reload
          expect(@word.synonyms.last.related_user_word.text).to eq('new_sym')
        end.to change { WordRelation.count }.by(1)
      end

      it 'should change word' do
        post :update, @post_arguments.merge(user_word: {text: 'new_text'})
        @word.reload
        expect(@word.text).to eq('new_text')
      end
    end
  end

  describe "Put 'create'" do
    before(:each) do
      test_sign_in(first_user)

      @category = FactoryGirl.create(:user_category, :name => "first", :is_default => true)
      @put_parameters = {user: first_user, translation_0: '', symonym_0: '', category_0: '',
                         user_word: {language_id: first_user.target_language.id, text: 'new_word', type_id: 1,
                                     custom_int_field1: 1, custom_string_field1: 'custom'}}
    end

    it 'should create word with correct attributes' do
      expect do
        put :create, @put_parameters.merge(translation_0: 'tran0', translation_1: 'tran1', synonym_0: 'syn0',
                                           category_0: 'cat0')
      end.to change(UserWord, :count)

      word = UserWord.find_by text: 'new_word'
      expect(word.translations.count).to eq(2)
      expect(word.synonyms.count).to eq(1)
      expect(word.user_word_categories.count).to eq(1)
      expect(word.type_id).not_to be(nil)
      expect(word.custom_int_field1).to eq(1)
      expect(word.custom_string_field1).to eq('custom')
    end

    it 'should add default category' do
      expect do
        put :create, @put_parameters.merge(category_1: @category.name)
      end.to change(UserWordCategory, :count).by(1)
    end
  end
end
