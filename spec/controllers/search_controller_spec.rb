require 'spec_helper'

describe SearchController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @attr = {:word => 'test'}
      @word = Factory(:word)
    end

    it "should create a new word if it doesn't exist" do
      post :create, :search => @attr
      response.code.should == "302"
      response.should redirect_to(new_word_path(:word => 'test'))
    end

    it "should open word's card if it exists" do
      post :create, :search => @word
      response.should redirect_to(word_path(@word))
    end
  end
end