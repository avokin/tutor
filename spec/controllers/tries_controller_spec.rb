require 'spec_helper'

describe TriesController do
  render_views

  before(:each) do
    @user = Factory(:user)
    test_sign_in(@user)
  end

  describe "GET 'index'" do
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Tutor - learn and repetition")
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @relation_translation = Factory(:word_relation_translation)
      @relation_synonym = Factory(:word_relation_synonym)
    end

    it "should show right word" do
      get :show, :id => @relation_translation.id
      response.should have_selector "div", :content => @relation_translation.source_user_word.word.text
    end

    it "should have the right title" do
      get :show, :id => @relation_translation.id
      response.should have_selector("title", :content => "Tutor - try")
    end
  end

  describe "POST 'check'" do
    describe "Wrong answer" do
      before(:each) do
        @relation = Factory(:word_relation_translation)
        Factory(:word_relation_translation)
        Factory(:word_relation_translation)
        Factory(:word_relation_translation)
        Factory(:word_relation_translation)
        @relation.success_count = 1
        @relation.status_id = 2
        @relation.save!
      end

      it "should redirect to show page with hint and change status to 'unlearned'" do
        @relation.success_count.should == 1
        @relation.status_id.should == 2
        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        post :check, :id => @relation.id, :answer => "wrong"
        @relation.reload
        @relation.success_count.should == 0
        @relation.status_id.should == 1
        response.should redirect_to try_path(@relation)

        get :show, :id => @relation.id
        response.should have_selector("div", :content => "Wrong answer")
      end
    end

    describe "Right answer" do
      before(:each) do
        @relation_translation = Factory(:word_relation_translation)
        @relation_translation2 = Factory(:word_relation_translation)
        @relation_translation3 = Factory(:word_relation_translation)
        Factory(:word_relation_synonym)
        Factory(:word_relation_synonym)
      end

      it "should increase success count and redirect to next word" do
        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        post :check, :id => @relation_translation.id, :answer => @relation_translation.related_user_word.word.text
        @relation_translation.reload
        @relation_translation.success_count.should == 1

        ok = response.location =~ /#{try_path(@relation_translation)}$/ ||
            response.location =~ /#{try_path(@relation_translation2)}$/ ||
            response.location =~ /#{try_path(@relation_translation3)}$/

        ok.should be_true
      end

      it "should mark relation as learned if user answered right 5 times" do
        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        @relation_translation.status_id.should == 1
        (1..5).each do
          post :check, :id => @relation_translation.id, :answer => @relation_translation.related_user_word.word.text
        end
        @relation_translation.reload
        @relation_translation.status_id.should == 2
      end
    end

    describe "Another translation but right one" do
      before(:each) do
        @relation_translation1 = Factory(:word_relation_translation)
        @relation_translation1.success_count = 1
        @relation_translation1.save!

        @relation_translation2 = Factory(:word_relation_translation)
        @relation_translation2.source_user_word = @relation_translation1.source_user_word
        @relation_translation2.save!
      end

      it "should not zero success count, but inform user that it expects another translation" do
        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        @relation_translation1.success_count.should == 1
        post :check, :id => @relation_translation1.id, :answer => @relation_translation2.related_user_word.word.text
        @relation_translation1.success_count.should == 1

        response.should redirect_to try_path(@relation_translation1)

        get :show, :id => @relation_translation1.id
        response.should have_selector("div", :content => "Another one")
      end
    end
  end

  describe "POST 'start'" do
    describe "targeting" do
      before(:each) do
        @relation_translation = Factory(:word_relation_translation)
        @relation_synonym = Factory(:word_relation_synonym)
      end

      describe "translations" do
        it "should redirect to WordRelation of type 'translation'" do
          post :start, :tries => {:targeting => "translations", :mode => "learning"}
          response.should redirect_to try_path(@relation_translation)
        end

        describe "several translation relation" do
          before(:each) do
            @relation_translation2 = Factory(:word_relation_translation)
            @relation_translation3 = Factory(:word_relation_translation)
          end

          it "should select one of the translations" do
            post :start, :tries => {:targeting => "translations", :mode => "learning"}
            ok = response.location =~ /#{try_path(@relation_translation)}$/ ||
                response.location =~ /#{try_path(@relation_translation2)}$/ ||
                response.location =~ /#{try_path(@relation_translation3)}$/

            ok.should be_true
          end
        end
      end

      describe "synonyms" do
        it "should redirect to WordRelation of type 'synonym'" do
          post :start, :tries => {:targeting => "synonyms", :mode => "learning"}
          response.should redirect_to try_path(@relation_synonym)
        end
      end
    end

    describe "'learning' mode" do
      it "should redirect to unlearned WordRelation" do
        @relation = Factory(:word_relation_translation)

        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        response.should redirect_to try_path(@relation)
      end

      it "should inform that there is no word to learn" do
        post :start, :tries => {:targeting => "translations", :mode => "learning"}
        response.should render_template("pages/message")
      end
    end

    describe "'repetition' mode" do
      it "should redirect to learned WordRelation" do
        @relation = Factory(:word_relation_translation)
        @relation.status_id = 2
        @relation.save!

        post :start, :tries => {:targeting => "translations", :mode => "repetition"}
        response.should redirect_to try_path(@relation)
      end

      it "should inform that there is no word to repeat" do
        post :start, :tries => {:targeting => "translations", :mode => "repetition"}
        response.should render_template("pages/message")
      end
    end

    describe "scope" do
      before(:each) do
        @word_count = 20
        @words_with_category = []
        (0..@word_count * 2).each do
          word_relation = Factory(:word_relation_translation)
          word_relation.source_user_word.save_with_relations(word_relation.user, nil, [], [], ["test_category"])
          @words_with_category << word_relation
        end

        @words_without_category = []
        (0..@word_count * 2).each do
          word_relation = Factory(:word_relation_translation)
          @words_without_category << word_relation
        end
      end

      describe "source: category" do
        it "should support scope 'all'" do
          post :start, :tries => {:targeting => "translations", :mode => "learning", :category => "test_category", :select => :all}
          @words_without_category.each do |relation_without_category|
            response.location.should_not =~ /#{try_path(relation_without_category)}$/
          end

          count = 0
          @words_with_category.each do |relation_with_category|
            if response.location =~ /#{try_path(relation_with_category)}$/
              count += 1
            end
          end

          count.should == 1
        end

        it "should support scope 'random'" do
          post :start, :tries => {:targeting => "translations", :mode => "learning", :category => "test_category", :select => :random}
          @words_without_category.each do |relation_without_category|
            response.location.should_not =~ /#{try_path(relation_without_category)}$/
          end

          count = 0
          @words_with_category.each do |relation_with_category|
            if response.location =~ /#{try_path(relation_with_category)}$/
              count += 1
            end
          end

          count.should == 1
        end

        it "should support scope 'recent'" do
          post :start, :tries => {:targeting => "translations", :mode => "learning", :category => "test_category", :select => :recent}
          @words_without_category.each do |relation_without_category|
            response.location.should_not =~ /#{try_path(relation_without_category)}$/
          end

          count = 0
          (0..@words_with_category.length).each do |i|
            relation_with_category = @words_with_category[i]
            if @words_with_category.length - i >= @word_count
              if response.location =~ /#{try_path(relation_with_category)}$/
                fail()
              else
                if response.location =~ /#{try_path(relation_with_category)}$/
                  count += 1
                end
              end
            end

            count.should == 1
          end
        end
      end



      describe "source: all dictionary" do
        it "should support scope 'all'" do
          pending
        end

        it "should support scope 'random 20'" do
          pending
        end

        it "should support scope 'recent 20'" do
          pending
        end
      end
    end
  end
end