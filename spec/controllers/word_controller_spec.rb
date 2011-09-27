require 'spec_helper'

describe WordsController do
  render_views

  before (:each) do
    user = Factory(:user)
    test_sign_in(user)
  end

  describe "POST 'create'" do
    describe 'creation of word that already exists in common dictionary' do
      before(:each) do
        @word = Factory(:word)
        @attr = {:word => @word.word, :language_id => @word.language_id}
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
        response.should redirect_to(word_path(1))
      end
    end

    describe 'creation a new Word in common dictionary' do
      before(:each) do
        @attr = {:word => 'test', :language_id => 1}
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
        response.should redirect_to(word_path(1))
      end
    end

    it "should redirect to error page if fail" do
      post :create
      response.should render_template('pages/message')
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @word = Factory(:word)
    end

    it 'should redirect to error page if user asks word that does not belong to him' do
      pending
    end

    it "should have the right title" do
      get :show, :id => @word.id
      response.should have_selector('title', :content => "Tutor - Card for word: word")
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @word = Factory(:word)
    end

    it 'should redirect to error page if user asks word that does not belong to him' do
      pending
    end

    it "should have the right title" do
      get :edit, :id => @word.id
      response.should have_selector('title', :content => "Tutor - Edit word: word")
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @attr = {:word => 'test'}
    end

    it "should have the right title" do
      get :new, :word => @attr[:word]
      response.should have_selector('title', :content => "Tutor - New word: test")
    end
  end

  describe "GET 'index'" do
    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => "Tutor - List of all words")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @word = Factory(:word)
    end

    describe "success" do
      before(:each) do
        @attr = {:word => 'test'}
      end

      it "should update word and redirect to show word page" do
        put :update, :id => @word.id, :word => @attr
        @word.reload
        @word.word.should == @attr[:word]
        response.should redirect_to(word_path(@word.id))
      end
    end

    describe "fail" do
      before(:each) do
        @attr = {:word => nil}
      end

      it "should render edit template" do
        put :update, :id => @word.id, :word => @attr
        response.should render_template 'pages/message'
      end
    end
  end
end