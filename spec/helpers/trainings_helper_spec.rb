require 'spec_helper'

describe TrainingsHelper do
  describe "fail_word" do
    before(:each) do
      @user_word = Factory(:english_user_word, )
      @translation1 = Factory(:word_relation_translation, :source_user_word => @user_word)
    end

    it "should zero translation_success_count" do
      fail_word @user_word
      @user_word.reload
      @user_word.translation_success_count.should == 0
    end
  end

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

      it "should increase time to check" do
        check_answers @user_word1, @answers, @answer_statuses
        @user_word1.reload
        @user_word1.time_to_check.should > DateTime.now
      end
    end
  end

  describe "skip" do
    before(:each) do
      @translation1 = Factory(:word_relation_translation)
      @user_word1 = @translation1.source_user_word
      @user_word1.translation_success_count = 1
      @user_word1.save!
    end

    it "should increase time to check" do
      skip @user_word1
      @user_word1.reload
      @user_word1.time_to_check.should > DateTime.now
    end
  end

  describe "select_user_word" do
    before(:each) do
      (1..10).each do
        Factory(:word_relation_translation)
      end
      (1..10).each do
        Factory(:word_relation_synonym)
      end

      @user = User.first
      @training = Training.new
      @training.user = @user
    end

    describe "type" do
      describe "translation" do
        describe "direction" do
          it "should fetch foreign word" do
            @training.direction = :direct
            selected_user_word = select_user_word(@training)
            selected_user_word.word.language.should_not == @user.language
            selected_user_word.translations.length.should > 0
          end

          it "should fetch native word" do
            @training.direction = :translation
            selected_user_word = select_user_word(@training)
            selected_user_word.word.language.should == @user.language
            selected_user_word.translations.length.should > 0
          end
        end
      end

      describe "synonym" do
        it "should fetch native word" do
          # ToDo
          #selected_user_word = select_user_word(@training)
          #selected_user_word.word.language.should_not == @user.language
          #selected_user_word.synonyms.length.should > 0
          pending
        end
      end
    end

    describe "fetching only ready words" do
      before(:each) do
        @translations = WordRelation.where(:relation_type => 1)
        @translations.each do |relation|
          if @translations.first != relation
            relation.source_user_word.time_to_check = DateTime.new(2101, 2, 3, 4, 5, 6)
            relation.source_user_word.save!
          end
        end
      end

      it "should fetch only ready word" do
        @training.direction = :direct
        selected_user_word = select_user_word(@training)
        selected_user_word.should == @translations.first.source_user_word
      end

      it "should fetch nothing if all words are not ready" do
        @translations.first.source_user_word.time_to_check = DateTime.new(2101, 2, 3, 4, 5, 6)
        @translations.first.source_user_word.save!

        @training.direction = :direct
        selected_user_word = select_user_word(@training)
        selected_user_word.should be_nil
      end
    end

    describe "scope" do
      before(:each) do
        @n = 10
        @user_word_category = Array.new(@n)
        (0..(@n-1)).each do |i|
          @user_word_category[i] = Factory(:user_word_category)
          user_word = @user_word_category[i].user_word
          Factory(:word_relation_translation, :source_user_word => user_word)
        end
        @fake_category = Factory(:user_category)
      end

      describe "nil" do
        it "should return any user word" do
          @training.direction = :direct
          selected_user_word = select_user_word(@training)
          selected_user_word.should_not be_nil
        end
      end

      describe "category" do
        it "should select the only word of current category" do
          @training.direction = :direct
          @training.user_category = @user_word_category[0].user_category
          selected_user_word = select_user_word(@training)
          selected_user_word.should == @user_word_category[0].user_word
        end

        it "should select nil if there is no a word with specified category" do
          @training.direction = :direct
          @training.user_category = @fake_category
          selected_user_word = select_user_word(@training)
          selected_user_word.should be_nil
        end
      end
    end
  end
end
