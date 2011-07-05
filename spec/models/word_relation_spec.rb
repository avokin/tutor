require 'spec_helper'

describe WordRelation do

  before(:each) do
    @word = Factory(:word)
    @attr = {:relation_type => 1}
  end

  describe "word relations" do
    before(:each) do
      @word_relation = @word.direct_translations.create(@attr)
      @related_word = Factory(:word)
      @word_relation.related_word = @related_word
    end
    it "Word relation must connect two words" do
      @word_relation.should respond_to(:source_word)
      @word_relation.source_word.should == @word
      @word_relation.related_word.should == @related_word
    end
  end

  it "should require relation_type" do
    empty_relation = WordRelation.new
    empty_relation.should_not be_valid
  end
end