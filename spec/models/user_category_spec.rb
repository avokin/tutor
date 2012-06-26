require 'spec_helper'

describe UserCategory do
  describe "find by user and name" do
    before(:each) do
      @category = Factory(:user_category)
      Factory(:user_category)
      @another_user = Factory(:user)
    end

    it "should find category for the first user" do
      UserCategory.find_by_user_and_name(User.first, @category.name).should == @category
    end

    it "shouldn't find category by the wrong name" do
      UserCategory.find_by_user_and_name(User.first, "wrong category name").should be_nil
    end

    it "shouldn't find category for another user" do
      UserCategory.find_by_user_and_name(@another_user, @category.name).should be_nil
    end
  end

  describe "delete category" do
    before(:each) do
      @user_word_category = Factory(:user_word_category)
      @user_category = @user_word_category.user_category

      @training = Factory(:training, :user_category => @user_category)
    end

    it "should delete relation to user words" do
      UserCategory.destroy(@user_category)
      UserWordCategory.find_by_id(@user_word_category.id).should be_nil
    end

    it "should delete relation to user words" do
      UserCategory.destroy(@user_category)
      Training.find_by_id(@training.id).should be_nil
    end
  end
end
