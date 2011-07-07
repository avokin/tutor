require 'spec_helper'

describe Word do

  it "should require content" do
    empty_word = Word.new
    empty_word.should_not be_valid
  end

  describe "related words" do
    before(:each) do
      @word1 = Factory(:word)
      @word2 = Factory(:word)
      @word3 = Factory(:word)

      @relation1 = @word1.direct_translations.create(:related_word_id => @word2.id, :relation_type => 1)
      @relation2 = @word2.direct_synonyms.create(:related_word_id => @word3.id, :relation_type => 2)

      @word2 = Word.find(@word2.id)
    end

    it "should have related word" do
      @word1.translations.count.should == 1
      @word1.synonyms.count.should == 0

      @word2.translations.count.should == 1
      @word2.synonyms.count.should == 1

      @word3.translations.count.should == 0
      @word3.synonyms.count.should == 1
    end
  end
end
