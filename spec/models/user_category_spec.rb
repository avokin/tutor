require 'spec_helper'

describe UserCategory do
  before(:each) do
    init_db
  end

  describe "find by user and name" do
    before(:each) do
      @category = FactoryGirl.create(:user_category)
      FactoryGirl.create(:user_category)
      @another_user = FactoryGirl.create(:user)
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
      @user_word_category = FactoryGirl.create(:user_word_category)
      @user_category = @user_word_category.user_category

      @training = FactoryGirl.create(:training, :user_category => @user_category)
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

  describe "merge" do
    describe "authorized access" do
      before(:each) do
        @merging_categories = Array.new
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id

        @word_count = @merging_categories.length
      end

      it "should delete merging categories" do
        first = @merging_categories[0]
        UserCategory.merge(first_user, @merging_categories).should be_true

        @merging_categories.each do |merging_category_id|
          UserCategory.exists?(merging_category_id).should == (first == merging_category_id)
        end
      end

      it "should move all words from merging categoreis to the main one" do
        UserCategory.merge(first_user, @merging_categories).should be_true

        main_category = UserCategory.find(@merging_categories[0])
        main_category.user_words.length.should == @word_count
      end
    end

    describe "unauthorized access" do
      before(:each) do
        @merging_categories = Array.new
        @merging_categories << FactoryGirl.create(:user_category, :user => second_user).id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id

        @word_count = @merging_categories.length
      end

      it "should return false in cause of categories of another user" do
        UserCategory.merge(first_user, @merging_categories).should be_false
      end

      it "should return false in cause of categories of another user" do
        UserCategory.merge(second_user, @merging_categories).should be_false
      end

      it "should not merge categories" do
        @merging_categories.each do |merging_category_id|
          UserCategory.exists?(merging_category_id).should be_true
          UserCategory.find(merging_category_id).user_words.length.should == (merging_category_id == @merging_categories[0] ? 0 : 1)
        end
      end
    end
  end
end
