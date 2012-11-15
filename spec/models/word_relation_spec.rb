require 'spec_helper'

describe WordRelation do

  before(:each) do
    init_db
    @user = FactoryGirl.create(:user)
    @user_word = FactoryGirl.create(:user_word)
  end

  describe 'create_relation' do
    before(:each) do
      @new_word_text = 'new_word'
    end

    it 'should create a new related word' do
      lambda do
        WordRelation.create_relation(@user, @user_word, @new_word_text, '1')
      end.should change(UserWord, :count).by(1)
      word_relation = WordRelation.first
      word_relation.should_not be_nil
      word_relation.source_user_word.should == @user_word
      word_relation.related_user_word.text.should == @new_word_text
      word_relation.relation_type.should == 1
    end
  end

  it "should require relation_type" do
    empty_relation = WordRelation.new
    empty_relation.should_not be_valid
  end
end