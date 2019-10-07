require 'spec_helper'

describe UserCategoriesController, :type => :controller do
  #render_views

  before(:each) do
    init_db
  end

  before(:each) do
    @user_word_category = FactoryBot.create(:user_word_category)
    @category = @user_word_category.user_category
    @user_word = @user_word_category.user_word
    @category_german = FactoryBot.create(:user_category, :language => german_language)
    @user = @user_word.user
  end

  describe "GET 'index'" do
    before(:each) do
      test_sign_in(@user)
    end

    it 'should have right title' do
      get :index
      expect(response.body).to have_title('Tutor - Your categories')
    end

    it 'should display only categories for current language' do
      get :index
      expect(response.body).to have_selector('a', :text => "#{@category.name}")
      expect(response.body).not_to have_selector('a', :text => "#{@category_german.name}")
    end
  end

  describe "DELETE 'destroy'" do
    describe 'unauthorized access' do
      describe 'not logged in user' do
        it 'should redirect to signin path' do
          delete :destroy, :id => @category.id
          expect(response).to redirect_to signin_path
        end
      end

      describe 'not owner user' do
        before(:each) do
          user = FactoryBot.create(:user)
          test_sign_in user
        end

        it 'should redirect to root path and display flash with error' do
          delete :destroy, :id => @category.id
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe 'authorized access' do
      before(:each) do
        test_sign_in @user
      end

      it 'should remove UserCategory record and all depending records' do
        expect do
          expect do
            delete :destroy, :id => @category.id
          end.to change(UserCategory, :count).by(-1)
        end.to change(UserWordCategory, :count).by(-1)
      end

      it 'should redirect to root path' do
        delete :destroy, :id => @category.id
        expect(response).to redirect_to user_categories_path
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      test_sign_in(@user)
    end

    describe 'creation a new Category' do
      it 'should create new UserCategory record' do
        expect do
          post :create, :user_category => {:name => 'new category'}
        end.to change(UserCategory, :count).by(1)
        expect(UserCategory.last.language).to eq @user.target_language
      end

      it 'should redirect to word list' do
        post :create, :user_category => {:name => 'new category'}
        expect(response).to redirect_to user_categories_path
      end
    end

    describe 'creation a new Category with already used name and language' do
      it "shouldn't create new Category" do
        expect do
          post :create, :user_category => {:name => @category.name}
        end.to_not change(UserCategory, :count)
      end

      it 'should redirect to error page' do
        post :create, :user_category => {:name => @category.name}
        expect(response).to render_template('pages/message')
      end
    end

    describe 'creation a new Category with already used name but not language' do
      before :each do
        @user.target_language = german_language
        @user.save!
      end

      it "shouldn't create new Category" do
        expect do
          post :create, :user_category => {:name => @category.name}
        end.to change(UserCategory, :count).by(1)
      end

      it 'should redirect to word list' do
        post :create, :user_category => {:name => @category.name}
        expect(response).to redirect_to user_categories_path
      end
    end
  end

  describe "PUT 'update'" do
    describe 'unauthorized access' do
      describe 'not logged in user' do
        it 'should redirect to signin path' do
          put :update, :id => @category
          expect(response).to redirect_to signin_path
        end
      end

      describe 'not owner user' do
        before(:each) do
          user = FactoryBot.create(:user)
          test_sign_in user
        end

        it 'should redirect to root path and display flash with error' do
          put :update, :id => @category
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe 'authorized access' do
      before(:each) do
        test_sign_in @user
      end

      it "should change name of the category and it's default state" do
        put :update, :id => @category.id, :user_category => {:name => 'new category', :is_default => true}, :btn_update => 'true'
        @category.reload
        expect(@category.name).to eq 'new category'
        expect(@category.is_default).to be true
      end

      it 'should redirect to category word list' do
        put :update, :id => @category.id, :user_category => {:name => 'new category'}, :btn_update => 'true'
        expect(response).to redirect_to user_category_path(@category)
      end
    end
  end

  describe "GET 'show'" do
    describe 'unauthorized access' do
      describe 'not logged in user' do
        it 'should redirect to signin path' do
          get :show, :id => @category.id
          expect(response).to redirect_to signin_path
        end
      end

      describe 'not owner user' do
        before(:each) do
          user = FactoryBot.create(:user)
          test_sign_in user
        end

        it 'should redirect to root path and display flash with error' do
          get :show, :id => @category.id
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe 'authrorized access' do
      before(:each) do
        test_sign_in @user
      end

      it 'should have right title' do
        get :show, :id => @category.id
        expect(response.body).to have_title("Tutor - #{@category.name}")
      end

      it 'should display words that correspond to the category' do
        get :show, :id => @category.id
        expect(response.body).to have_selector('a', :text => @user_word.text)
      end

      it "should display the 'Edit' link" do
        get :show, :id => @category.id
        expect(response.body).to have_selector('a', :text => 'Edit')
      end
    end
  end

  describe "GET 'new'" do
    before(:each) do
      test_sign_in @user
    end

    it 'should have right title' do
      get :new
      expect(response.body).to have_title('Tutor - New category')

      expect(response.body).to have_selector('li.active') do |li|
        expect(li).to have_selector('a', :text => 'Categories')
      end
    end
  end

  describe "GET 'edit'" do
    describe 'unauthorized access' do
      describe 'not logged in user' do
        it 'should redirect to signin path' do
          get :edit, :id => @category.id
          expect(response).to redirect_to signin_path
        end
      end

      describe 'not owner user' do
        before(:each) do
          user = FactoryBot.create(:user)
          test_sign_in user
        end

        it 'should redirect to root path and display flash with error' do
          get :edit, :id => @category.id
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe 'authorized access' do
      before(:each) do
        test_sign_in @user
      end

      it 'should have right title' do
        get :edit, :id => @category.id
        expect(response.body).to have_title("Tutor - Edit category: #{@category.name}")
        expect(response.body).to have_selector('li.active') do |li|
          expect(li).to have_selector('a', :content => 'Categories')
        end
      end
    end
  end

  describe "PUT 'merge'" do
    before(:each) do
      @user_word_category = FactoryBot.create(:user_word_category)
      @category2 = @user_word_category.user_category
    end

    describe 'unauthorized access' do
      describe 'not logged in user' do
        it 'should redirect to signin path' do
          put :merge, :ids => "#{@category.id}, #{@category2.id}"
          expect(response).to redirect_to signin_path
        end
      end

      describe 'not owner user' do
        before(:each) do
          user = FactoryBot.create(:user)
          test_sign_in user
        end

        it 'should redirect to root path and display flash with error' do
          put :merge, :ids => "#{@category.id}, #{@category2.id}"
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe 'authorized access' do
      before(:each) do
        test_sign_in @user
      end

      it 'should move all words to the first category' do
        words_to_move = @category2.user_words
        put :merge, :ids => "#{@category.id}, #{@category2.id}"

        words_to_move.each do |word|
          word.reload
          expect(word.user_category.first).to eq @category
        end
      end

      it 'should remove all categories except the first' do
        put :merge, :ids => "#{@category.id}, #{@category2.id}"
        expect(UserCategory.find_by_id(@category2.id)).to be_nil
      end
    end
  end
end