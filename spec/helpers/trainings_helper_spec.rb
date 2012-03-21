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
    before(:each) do
      (1..10).each do |i|
        Factory(:word_relation_translation)
      end
      (1..10).each do |i|
        Factory(:word_relation_synonym)
      end

      @user = User.first
    end

    describe "type" do
      describe "translation" do
        describe "direction" do
          it "should fetch foreign word" do
            selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :learning)
            selected_user_word.word.language.should_not == @user.language
            selected_user_word.translations.length.should > 0
          end

          it "should fetch native word" do
            selected_user_word = select_user_word(@user, nil, :native_foreign, :translation, :learning)
            selected_user_word.word.language.should == @user.language
            selected_user_word.translations.length.should > 0
          end
        end
      end

      describe "synonym" do
        it "should fetch native word" do
          selected_user_word = select_user_word(@user, nil, :nil, :synonym, :learning)
          selected_user_word.word.language.should_not == @user.language
          selected_user_word.synonyms.length.should > 0
        end
      end
    end

    describe "mode" do
      describe "learning" do
        before(:each) do
          @translations = WordRelation.where(:relation_type => 1)
          @translations.each do |relation|
            relation.source_user_word.translation_success_count = 10
            relation.source_user_word.save!
          end
        end

        describe "the only unlearned word" do
          before(:each) do
            @first_translation = @translations.first
            @first_translation.source_user_word.translation_success_count = 0
            @first_translation.source_user_word.save!
          end

          it "should select the only unlearned word" do
            selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :learning)
            selected_user_word.should == @first_translation.source_user_word
          end
        end

        describe "all words are learned" do
          it "should not select any word" do
            selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :learning)
            selected_user_word.should be_nil
          end
        end
      end

      describe "repetition" do
        describe "the only learned word" do
          before(:each) do
            @translations = WordRelation.where(:relation_type => 1)
            @first_translation = @translations.first
            @first_translation.source_user_word.translation_success_count = 10
            @first_translation.source_user_word.save!
          end

          it "should select the only learned word" do
            selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :repetition)
            selected_user_word.should == @first_translation.source_user_word
          end
        end

        describe "all words are unlearned" do
          it "should not select any word" do
            selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :repetition)
            selected_user_word.should be_nil
          end
        end
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
          selected_user_word = select_user_word(@user, nil, :foreign_native, :translation, :learning)
          selected_user_word.should_not be_nil
        end
      end

      describe "category" do
        it "should select the only word of current category" do
          selected_user_word = select_user_word(@user, @user_word_category[0].user_category.id, :foreign_native, :translation, :learning)
          selected_user_word.should == @user_word_category[0].user_word
        end

        it "should select nil if there is no a word with specified category" do
          selected_user_word = select_user_word(@user, @fake_category.id, :foreign_native, :translation, :repetition)
          selected_user_word.should be_nil
        end
      end
    end
  end
end
