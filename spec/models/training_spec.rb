require 'spec_helper'

describe Training do
  describe "creation of Training object" do
    before(:each) do
      @attr = {:direction => :direct}
    end

    it "should create a new instance without user-category" do
      Training.create! @attr
    end

    it "should create a new instance with user-category" do
      @user_category = Factory(:user_category)
      training = Training.create! @attr.merge(:user_category => @user_category)
      training.user_category.should == @user_category
    end
  end
end
