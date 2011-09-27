require 'spec_helper'

describe UserWord do
  before(:each) do
    @user = Factory(:user)
  end

  describe 'create UserWord with relations' do
    before(:each) do
      @translations = ['translation1', 'translation2']
      @synonyms = ['synonym1']
    end

    describe 'successful creation of UserWord' do
      before(:each) do
        @text = 'test_word'
      end

      it 'should create Word if needed' do
        lambda do
          lambda do
            UserWord.save_with_relations(@user, @text, @translations, [], [])
          end.should change(Word, :count).by(3)
        end.should change(UserWord, :count).by(3)
      end

      it 'should not create Word if it exists' do
        word = Factory(:word)
        lambda do
          lambda do
            UserWord.save_with_relations(@user, word.word, @translations, @synonyms, [])
          end.should change(Word, :count).by(3)
        end.should change(UserWord, :count).by(4)
      end

      it 'should create translations' do
        lambda do
          UserWord.save_with_relations(@user, @text, @translations, [], [])
        end.should change(UserWord, :count).by(3)
      end

      it 'should create synonyms' do
        lambda do
          UserWord.save_with_relations(@user, @text, [], @synonyms, [])
        end.should change(UserWord, :count).by(2)
      end
    end

    describe 'unsuccessful creation of UserWord' do
      before(:each) do
        @text = ''
      end

      it 'should not create a Word' do
        @result
        lambda do
          lambda do
            @result = UserWord.save_with_relations(@user, @text, @translations, [], [])
          end.should_not change(UserWord, :count)
        end.should_not change(Word, :count)
        @result.should == false
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

  describe 'delete UserWord' do
    it 'should delete UserWord and relations' do
      pending
    end

    it 'should not delete the Word' do
      pending
    end
  end
end
