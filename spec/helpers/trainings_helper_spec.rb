require 'spec_helper'

describe TrainingsHelper do
  describe "check_answers" do
    before(:each) do
      @translation1 = Factory(:word_relation_translation)
      @user_word1 = @translation1.source_user_word
      @translation2 = Factory(:word_relation_translation, :source_user_word => @user_word1)
      @answer_statuses = Hash.new
      @answers = Array.new
    end

    describe "failure" do
      before(:each) do
        @answers << @translation1.related_user_word.word.text
        @answers << ""
      end

      it "should return false" do
        ok = check_answers @user_word1, @answers, @answer_statuses
        ok.should be_false
      end

      it "should zero success counter" do
        @user_word1.translation_success_count = 1
        @user_word1.save!
        check_answers @user_word1, @answers, @answer_statuses
        @user_word1.reload
        @user_word1.translation_success_count.should == 0
      end

      it "should mark incorrect answers" do
        check_answers @user_word1, @answers, @answer_statuses
        @answer_statuses[@translation1.related_user_word.word.text].should be_true
        @answer_statuses[""].should be_false
      end
    end

    describe "success" do
      before(:each) do
        @answers << @translation1.related_user_word.word.text
        @answers << @translation2.related_user_word.word.text
      end

      it "should return true" do
        ok = check_answers @user_word1, @answers, @answer_statuses
        ok.should be_true
      end

      it "should increase success count" do
        check_answers @user_word1, @answers, @answer_statuses
        @user_word1.reload
        @user_word1.translation_success_count.should == 1
      end

      it "should not mark any error" do
        check_answers @user_word1, @answers, @answer_statuses
        @answer_statuses[@translation1.related_user_word.word.text].should be_true
        @answer_statuses[@translation1.related_user_word.word.text].should be_true
      end
    end
  end

  describe "select_user_word" do
    pending
  end
end
