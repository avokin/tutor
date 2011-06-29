require 'spec_helper'

describe WordRelation do

  before(:each) do
    @word = Factory(:word)
    @attr = {:relation_type => 1}
  end

  describe "word relations" do
    before(:each) do
      @word_relation = @word.direct_translations.create(@attr)
    end
    it "Word relation must connect two words" do
      @word_relation.should respond_to(:source_word)
      @word_relation.source_word.should == @word
    end
  end
end