require 'spec_helper'

describe Training do
  describe "creation of Training object" do
    before(:each) do
      @user = Factory(:user)
      @attr = {:direction => :direct}
      @user_category = Factory(:user_category)
      @another_user = Factory(:user)
    end

    it "should create a new instance without user-category" do
      training = Training.new @attr
      training.user = @user
      training.save!
    end

    it "should create a new instance with user-category" do
      training = Training.new @attr.merge(:user_category => @user_category)
      training.user = @user
      training.save!
      training.user_category.should == @user_category
    end

    it "should not get user from parameter" do
      training = Training.new @attr.merge(:user_category => @user_category, :user => @user)
      training.should_not be_valid
    end

    it "should not bind category of another user" do
      training = Training.new @attr.merge(:user_category => @user_category)
      training.user = @another_user
      training.should_not be_valid
    end

    it "should validate uniqueness of user_category_id and direction" do
      training1 = Training.new @attr.merge(:user_category => @user_category)
      training1.user = @user
      training1.save!

      training2 = Training.new @attr.merge(:user_category => @user_category)
      training2.user = @user
      training2.should_not be_valid
    end
  end

  describe "find_by_user method" do
    before(:each) do
      @training = Factory(:training)
      @another_user = Factory(:user)
      @user_category = Factory(:user_category, :user => @another_user)
      @training_of_another_user = Factory(:training, :user_category => @user_category, :user => @another_user)
    end

    it "should find all Training object for user" do
      @trainings = Training.find_all_by_user_id @training.user.id
      @trainings.length.should == 1
      @trainings.first.should == @training
    end
  end
end
