require 'spec_helper'

describe SearchController do
  render_views

  before(:each) do
    @attr = {:word => 'test'}
  end

  describe "POST 'create'" do
    it "should " do
      post :create, :search => @attr
      response.code.should == "302"
      response.should redirect_to(new_word_path(:word => 'test'))
    end
  end

end