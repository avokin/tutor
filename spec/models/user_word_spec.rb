require 'spec_helper'

describe UserWord do
  before(:each) do
    @user = Factory(:user)
  end

  describe "should have related words" do
    before(:each) do
      @user_word1 = Factory(:user_word)
      @user_word2 = Factory(:user_word)
      @user_word3 = Factory(:user_word)

      @relation1 = @user_word1.direct_translations.create(:related_user_word_id => @user_word2.id, :relation_type => 1, :user_id => @user.id)
      @relation1.user = @user
      @relation1.save!()
      @relation2 = @user_word2.direct_synonyms.create(:related_user_word_id => @user_word3.id, :relation_type => 2, :user => @user)
      @relation2.user = @user
      @relation2.save!()
    end

    it "should have related word" do
      @user_word1.translations.count.should == 1
      @user_word1.synonyms.count.should == 0

      @user_word2.translations.count.should == 1
      @user_word2.synonyms.count.should == 1

      @user_word3.translations.count.should == 0
      @user_word3.synonyms.count.should == 1
    end
  end

  describe 'create UserWord with relations' do
    before(:each) do
      @translations = ['translation1', 'translation2']
      @synonyms = ['synonym1']
      @categories = ["category1"]
    end

    describe 'successful creation of UserWord' do
      before(:each) do
        @text = 'test_word'
        @user_word = UserWord.new :user_id => @user.id
      end

      it "should create Word if needed" do
        lambda do
          lambda do
            @user_word.save_with_relations(@user, @text, @translations, [], [])
          end.should change(Word, :count).by(3)
        end.should change(UserWord, :count).by(3)
      end

      it "should not create Word if it exists" do
        word = Factory(:word)
        lambda do
          lambda do
            @user_word.save_with_relations(@user, word.text, @translations, @synonyms, [])
          end.should change(Word, :count).by(3)
        end.should change(UserWord, :count).by(4)
      end

      it "should create translations" do
        lambda do
          @user_word.save_with_relations(@user, @text, @translations, [], [])
        end.should change(UserWord, :count).by(3)
      end

      it "should create synonyms" do
        lambda do
          @user_word.save_with_relations(@user, @text, [], @synonyms, [])
        end.should change(UserWord, :count).by(2)
      end

      it "should create category" do
        lambda do
          lambda do
            @user_word.save_with_relations(@user, @text, [], @synonyms, @categories)
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
          lambda do
            @result = @user_word.save_with_relations(@user, @text, @translations, [], [])
          end.should_not change(UserWord, :count)
        end.should_not change(Word, :count)
        @user_word.should be_true
      end
    end
  end

  describe 'rename UserWord' do
    before(:each) do
      @word = Factory(:word)
      @user_word = Factory(:user_word)
    end

    describe 'successful rename' do
      before(:each) do
        @new_word = 'new_word'
      end

      it 'should change reference to Word' do
        lambda do
          lambda do
            @user_word.rename(@new_word)
          end.should change(Word, :count).by(1)
        end.should_not change(UserWord, :count)
        @user_word.word.should == Word.last
      end
    end

    describe 'unsuccessful rename' do
      before(:each) do
        @new_word = ''
      end

      it 'should not change anything' do
        lambda do
          lambda do
            @user_word.rename(@new_word)
          end.should_not change(Word, :count)
        end.should_not change(UserWord, :count)
        @user_word.word.should == Word.last
      end
    end
  end

  describe 'find_for_user' do
    before(:each) do
      @user_word1 = Factory(:user_word)
      @user2 = Factory(:user)
    end

    it 'should not find word of another user' do
      UserWord.find_for_user(@user2, @user_word1.word.text).should be_nil
    end

    it 'should find word of current user' do
      UserWord.find_for_user(@user_word1.user, @user_word1.word.text).should_not be_nil
    end
  end

  describe "relation with categories" do
    before(:each) do
      @user_word_category = Factory(:user_word_category)
      @user_word = @user_word_category.user_word
      @user_category = @user_word_category.user_category
    end

    it "should have list of category" do
      @user_word.user_categories.length.should == 1
      @user_word.user_categories[0].should == @user_category
    end
  end
end
