require 'spec_helper'

describe Word do

  it "should require content" do
    empty_word = Word.new
    empty_word.should_not be_valid
  end
end
