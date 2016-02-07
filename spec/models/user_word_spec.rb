require 'spec_helper'

describe UserWord do
  before(:each) do
    init_db
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'should have related words' do
    before(:each) do
      @user_word1 = FactoryGirl.create(:english_user_word)
      @user_word2 = FactoryGirl.create(:english_user_word)
      @user_word3 = FactoryGirl.create(:english_user_word)

      @relation1 = @user_word1.direct_translations.create(:related_user_word_id => @user_word2.id, :relation_type => 1, :user_id => @user.id, :status_id => 1)
      @relation1.user = @user
      @relation1.save!
      @relation2 = @user_word2.direct_synonyms.create(:related_user_word_id => @user_word3.id, :relation_type => 2, :user => @user, :status_id => 1)
      @relation2.user = @user
      @relation2.save!
    end

    it 'should have related word' do
      @user_word1.translations.count.should == 1
      @user_word1.synonyms.count.should == 0

      @user_word2.translations.count.should == 1
      @user_word2.synonyms.count.should == 1

      @user_word3.translations.count.should == 0
      @user_word3.synonyms.count.should == 1
    end
  end

  describe 'creation UserWord with relations' do
    before(:each) do
      @translations = ['translation1', 'translation2']
      @synonyms = ['synonym1']
      @categories = ["category1"]
    end

    describe 'successful creation of UserWord' do
      before(:each) do
        @text = 'test_word'
        @user_word = UserWord.new :user => @user, :text => @text, :language_id => @user.target_language.id
      end

      it "should create Word if needed" do
        lambda do
          @user_word.save_with_relations(@translations, [], [])
        end.should change(UserWord, :count).by(3)
      end

      it "should not create Word if it exists" do
        lambda do
          @user_word.save_with_relations(@translations, @synonyms, [])
        end.should change(UserWord, :count).by(4)
      end

      it "should create translations" do
        lambda do
          @user_word.save_with_relations(@translations, [], [])
        end.should change(UserWord, :count).by(3)
      end

      it "should create synonyms" do
        lambda do
          @user_word.save_with_relations([], @synonyms, [])
        end.should change(UserWord, :count).by(2)
      end

      it "should create category" do
        lambda do
          lambda do
            @user_word.save_with_relations([], @synonyms, @categories)
          end.should change(UserWordCategory, :count).by(1)
        end.should change(UserCategory, :count).by(1)
      end
    end

    describe 'unsuccessful creation of UserWord' do
      before(:each) do
        @text = ''
        @user_word = UserWord.new :user_id => @user.id
      end

      it 'should not create a Word' do
        lambda do
          @result = @user_word.save_with_relations(@translations, [], [])
        end.should_not change(UserWord, :count)
      end
    end
  end

  describe "updating Word with relations" do
    describe "categories" do
      before(:each) do
        word_category = FactoryGirl.create(:user_word_category)
        @word = word_category.user_word
        @category = word_category.user_category
        @new_cagegory_name = "new_category"
      end

      it "should add new categories from the list" do
        @word.save_with_relations([], [], [@category.name, @new_cagegory_name])
        @word.user_categories.length.should == 2
        @word.user_categories[0].name.should == @category.name
        @word.user_categories[1].name.should == @new_cagegory_name
      end

      it "should remove categories missed in the list" do
        @word.save_with_relations([], [], [@new_cagegory_name])
        @word.user_categories.length.should == 1
        @word.user_categories[0].name.should == @new_cagegory_name
      end
    end
  end

  describe 'find_for_user' do
    before(:each) do
      @user_word1 = FactoryGirl.create(:english_user_word)
      @user2 = FactoryGirl.create(:user)
    end

    it 'should not find word of another user' do
      UserWord.find_for_user(@user2, @user_word1.text).should be_nil
    end

    it 'should find word of current user' do
      UserWord.find_for_user(@user_word1.user, @user_word1.text).should_not be_nil
    end
  end

  describe "relation with categories" do
    before(:each) do
      @user_word_category = FactoryGirl.create(:user_word_category)
      @user_word = @user_word_category.user_word
      @user_category = @user_word_category.user_category
    end

    it "should have list of category" do
      @user_word.user_categories.length.should == 1
      @user_word.user_categories[0].should == @user_category
    end
  end

  describe "save_attempt" do
    before(:each) do
      @user_word = FactoryGirl.create(:english_user_word, :translation_success_count => 1)
    end

    describe "failed attempt" do
      before(:each) do
        @user_word.save_attempt false
        @user_word.reload
      end

      it "should zero translation_success_count" do
        @user_word.translation_success_count.should == 0
      end

      it "should set time_to_check 4 hours after" do
        @user_word.time_to_check.should > DateTime.now + 3.hours
        @user_word.time_to_check.should < DateTime.now + 5.hours
      end
    end

    describe "successful attempt" do
      before(:each) do
        @user_word.save_attempt true
        @user_word.reload
      end

      it "should increase translation_success_count" do
        @user_word.translation_success_count.should == 2
      end

      it "should set time_to_check 4 hours after" do
        @user_word.time_to_check.should > DateTime.now + 7.hours
        @user_word.time_to_check.should < DateTime.now + 9.hours
      end
    end
  end
end
