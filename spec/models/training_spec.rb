require 'spec_helper'

describe Training do
  before(:each) do
    init_db
  end

  describe "creation of Training object" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @attr = {:direction => :direct}
      @user_category = FactoryGirl.create(:user_category)
      @another_user = FactoryGirl.create(:user)
    end

    it "should not create a new instance without user-category" do
      training = Training.new @attr
      training.user = @user
      training.valid?.should be_false
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

  describe "find_by_user" do
    before(:each) do
      @training = FactoryGirl.create(:training)
      @another_user = FactoryGirl.create(:user)
      @user_category = FactoryGirl.create(:user_category, :user => @another_user)
      @training_of_another_user = FactoryGirl.create(:training, :user_category => @user_category, :user => @another_user)
    end

    it "should find all Training object for user" do
      @trainings = Training.find_all_by_user_id @training.user.id
      @trainings.length.should == 1
      @trainings.first.should == @training
    end
  end

  describe "get_ready_user_words" do
    before(:each) do
      @training = FactoryGirl.create(:training)
      @english_words = Array.new
      (1..40).each do |i|
        if i % 2 == 0
          english_word = FactoryGirl.create(:english_user_word, :time_to_check => DateTime.new(2021,2,3,4,5,6))
        else
          english_word = FactoryGirl.create(:english_user_word)
        end

        FactoryGirl.create(:word_relation_translation, :source_user_word => english_word)
        @english_words << english_word
        FactoryGirl.create(:user_word_category, :user_word => english_word, :user_category => @training.user_category)
      end
    end

    it "should return only ready words for the page" do
      @words_on_page_1 = @training.get_ready_user_words(1)
      @words_on_page_1.size.should == 10

      @words_on_page_1.should include(@english_words[0])
      @words_on_page_1.should_not include(@english_words[1])
      @words_on_page_1.should include(@english_words[2])
      @words_on_page_1.should_not include(@english_words[3])
      @words_on_page_1.should include(@english_words[4])

      @words_on_page_2 = @training.get_ready_user_words(2)
      @words_on_page_2.size.should == 10
      @words_on_page_2.should include(@english_words[20])
      @words_on_page_2.should_not include(@english_words[21])
      @words_on_page_2.should include(@english_words[22])
      @words_on_page_2.should_not include(@english_words[23])
      @words_on_page_2.should include(@english_words[24])
    end

    it "should return only ready words for the entire training" do
      @words_on_page_2 = @training.get_ready_user_words(nil)
      @words_on_page_2.size.should == 20
    end
  end

  describe "get_user_words" do
    before(:each) do
      @training = FactoryGirl.create(:training)
      @user_word = FactoryGirl.create(:english_user_word, :time_to_check => DateTime.new(2021,2,3,4,5,6))
      FactoryGirl.create(:user_word_category, :user_word => @user_word, :user_category => @training.user_category)

      FactoryGirl.create(:word_relation_translation, :source_user_word => @user_word)
      FactoryGirl.create(:word_relation_translation, :source_user_word => @user_word)
    end

    it "should return corresponding words only once" do
      @words_on_page_1 = @training.get_user_words(1)
      @words_on_page_1.size.should == 1

      @words_on_page_1.should include(@user_word)
    end
  end
end
