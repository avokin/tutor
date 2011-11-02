require 'spec_helper'

describe UserWordsController do
  render_views

  before(:each) do
    @user = Factory(:user)
    test_sign_in(@user)
  end

  describe "GET 'show'" do
    before(:each) do
      @user_word1 = Factory(:user_word)
      test_sign_in(@user_word1.user)

      @user_word2 = Factory(:user_word_for_another_user)
    end

    it 'should redirect to error page if user asks word that does not belong to him' do
      get :show, :id => @user_word2.id
      response.should render_template('pages/message')
    end

    it "should have the right title" do
      get :show, :id => @user_word1.id
      response.should have_selector('title', :content => "Tutor - Card for word: #{@user_word1.word.text}")
    end
  end

  describe "GET 'recent'" do
    before(:each) do
      @user_words = Array.new
      (0..99).each do |i|
        @user_words[i] = Factory(:user_word)
      end
    end

    it 'should display only first 50 words' do
      get :recent

      (0..49).each do |i|
        response.should_not have_selector('a', :href => user_word_path(@user_words[i]), :content => @user_words[i].word.text)
      end

      (50..99).each do |i|
        response.should have_selector('a', :href => user_word_path(@user_words[i]), :content => @user_words[i].word.text)
      end
    end

    it "should have the right title" do
      get :recent
      response.code.should == "200"
      response.should have_selector('title', :content => "Tutor - Your recent words")
    end
  end

  describe "GET 'index'" do
    before(:each) do
      @user_word1 = Factory(:user_word)
      @user_word2 = Factory(:user_word_for_another_user)
    end

    it "should have the right title" do
      get :index
      response.code.should == "200"
      response.should have_selector('title', :content => "Tutor - Your words")
    end

    it 'should not display words of other users' do
      test_sign_in(@user_word1.user)
      get :index
      response.should have_selector('a', :href => user_word_path(@user_word1), :content => @user_word1.word.text)
      response.should_not have_selector('a', :href => user_word_path(@user_word2), :content => @user_word2.word.text)
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user_word1 = Factory(:user_word)
      test_sign_in(@user_word1.user)

      @user_word2 = Factory(:user_word_for_another_user)
    end

    it 'should redirect to error page if user asks word that does not belong to him' do
      get :edit, :id => @user_word2.id
      response.should render_template 'pages/message'
    end

    it "should have the right title" do
      get :edit, :id => @user_word1.id
      response.should have_selector('title', :content => "Tutor - Edit word: #{@user_word1.word.text}")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have right title" do
      get :new
      response.should have_selector("title", :content => "Tutor - New word")
    end
  end

  describe "POST 'create'" do
    describe 'creation of word that already exists in common dictionary' do
      before(:each) do
        @word = Factory(:word)
        @attr = {:text => @word.text, :language_id => @word.language_id}
      end

      it 'should not create a new common Word' do
        lambda do
          post :create, :word => @attr
        end.should_not change(Word, :count)
      end

      it 'should create new UserWord entity' do
        lambda do
          post :create, :word => @attr
        end.should change(UserWord, :count).by(1)
      end

      it "should redirect to word's card if successful" do
        post :create, :word => @attr
        response.code.should == "302"
        response.should redirect_to(user_word_path(1))
      end
    end

    describe 'creation a new Word in common dictionary' do
      before(:each) do
        @attr = {:text => 'test', :language_id => 1}
      end

      it 'should create a new common Word' do
        lambda do
          post :create, :word => @attr
        end.should change(Word, :count).by(1)
      end

      it 'should create new UserWord entity' do
        lambda do
          post :create, :word => @attr
        end.should change(UserWord, :count).by(1)
      end

      it "should redirect to word's card if successful" do
        post :create, :word => @attr
        response.code.should == "302"
        response.should redirect_to(user_word_path(1))
      end

      it "should parse translations suggested by online dictionaries" do
        lambda do
          post :create, :word => @attr, :suggested_translation_1 => 'suggested translation'
        end.should change(UserWord, :count).by(2)
      end
    end

    it "should redirect to error page if fail" do
      post :create, :word => Word.new
      response.should render_template('pages/message')
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @relation = Factory(:word_relation_translation)
      test_sign_in(@relation.source_user_word.user)
      @another_user = Factory(:user)
    end

    it 'should not delete UserWord of another user' do
      test_sign_in(@another_user)
      lambda do
        lambda do
          lambda do
            delete :destroy, :id => @relation.source_user_word.id
          end.should_not change(UserWord, :count)
        end.should_not change(WordRelation, :count)
      end.should_not change(Word, :count)
      response.should render_template 'pages/message'
    end

    it 'should delete UserWord, WordRelations and do not delete Word' do
      lambda do
        lambda do
          lambda do
            delete :destroy, :id => @relation.source_user_word.id
          end.should change(UserWord, :count).by(-1)
        end.should change(WordRelation, :count).by(-1)
      end.should_not change(Word, :count)
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user_word = Factory(:user_word)
      test_sign_in @user_word.user
    end

    it 'should add translation, synonym' do
      lambda do
        lambda do
          lambda do
            put :update, :id => @user_word.id, :translation_0 => 'new translation', :synonym_0 => 'new synonym'
          end.should change(UserWord, :count).by(2)
        end.should change(Word, :count).by(2)
      end.should change(WordRelation, :count).by(2)
    end

    it 'should change word and not to delete old word' do
      lambda do
        lambda do
          put :update, :id => @user_word.id, :word => {:text => 'new word'}
        end.should_not change(UserWord, :count)
      end.should change(Word, :count).by(1)

      @user_word = UserWord.find(@user_word.id)
      @user_word.word.text.should == 'new word'
    end

    it 'should change only link if renamed word exist' do
      word = Factory(:word)

      lambda do
        lambda do
          put :update, :id => @user_word.id, :word => {:text => word.text}
        end.should_not change(UserWord, :count)
      end.should_not change(Word, :count)

      @user_word = UserWord.find(@user_word.id)
      @user_word.word.should == word
    end

    it 'should create only relation if either source and related word exist' do
      user_word2 = Factory(:user_word)

      lambda do
        lambda do
          lambda do
            put :update, :id => @user_word.id, :translation_0 => user_word2.word.text
          end.should change(WordRelation, :count).by(1)
        end.should_not change(Word, :count)
      end.should_not change(UserWord, :count)
      response.should redirect_to user_word_path(@user_word)
    end
  end
end
