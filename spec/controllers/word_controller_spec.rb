require 'spec_helper'

describe WordsController do
  render_views

  before(:each) do
    @attr = {:word => 'test'}
  end

  describe "POST 'create'" do
    it "should " do
      post :create, :word => @attr
      response.code.should == "302"
      response.should redirect_to(word_path(1))
    end
  end
end