require 'spec_helper'

describe WordRelation do

  before(:each) do
    init_db
    @user = FactoryGirl.create(:user)
    @user_word = FactoryGirl.create(:english_user_word)
  end

  describe 'create_relation' do
    before(:each) do
      @new_word_text = 'new_word'
    end

    it 'should create a new related word' do
      expect do
        WordRelation.create_relation(@user, @user_word, @new_word_text, '1')
      end.to change(UserWord, :count).by(1)
      word_relation = WordRelation.first
      expect(word_relation).to_not be_nil
      expect(word_relation.source_user_word).to eq @user_word
      expect(word_relation.related_user_word.text).to eq @new_word_text
      expect(word_relation.relation_type).to eq 1
    end
  end

  describe 'validation' do
    before(:each) do
      @synonym = FactoryGirl.create(:word_relation_synonym)
    end

    it 'should not create duplicated relation when there is the same direct relation exist' do
      expect do
        WordRelation.create_relation(@user, @synonym.source_user_word, @synonym.related_user_word.text, '2')
      end.not_to change { WordRelation.count }
    end

    it 'should not create duplicated relation when there is the same backward relation exist' do
      expect do
        WordRelation.create_relation(@user, @synonym.related_user_word, @synonym.source_user_word.text, '2')
      end.not_to change { WordRelation.count }
    end
  end

  it "should require relation_type" do
    empty_relation = WordRelation.new
    expect(empty_relation).to_not be_valid
  end
end