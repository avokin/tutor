require 'spec_helper'

describe WordRelation do

  before(:each) do
    @word = Factory(:word)
    @attr = {:relation_type => 1}
  end

  describe "create_relation" do
    before(:each) do
      @word1 = Factory(:word)
    end
    it "should create a new related word" do
      relation = WordRelation.create_relation(@word1.id, "new text", "1")
      relation.should_not be_nil
      relation.source_word.should == @word1
      relation.related_word.word.should == "new text"
      relation.relation_type.should == 1
    end
  end

  describe "delete relation" do
    #ToDo
  end

  it "should require relation_type" do
    empty_relation = WordRelation.new
    empty_relation.should_not be_valid
  end
end