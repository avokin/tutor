require 'spec_helper'

describe WordRelationsController do
  render_views

  describe "POST 'create'" do

    before(:each) do
      @word = Factory(:word)
    end

    describe "fail" do

      describe "fail if incorrect relation type" do
        before(:each) do
          @attr = {:word_id => @word.id, :related_word => 'related_word', :relation_type => "0"}
        end

        it "should fail because of non-existed word" do
          lambda do
            post :create, :word_relation => @attr
          end.should_not change(WordRelation, :count)
          response.should render_template('pages/message')
        end
      end

      describe "fail if can't save relation'" do
        before(:each) do
          @attr = {:word_id => @word.id, :related_word => nil, :relation_type => "1"}
        end

        it "should fail because of empty related word" do
          lambda do
            post :create, :word_relation => @attr
          end.should_not change(WordRelation, :count)
          response.should render_template('pages/message')
        end
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:word_id => @word.id, :related_word => 'related_word', :relation_type => "1"}
      end

      it "should create a new Word and a new WordRelation" do
        lambda do
          post :create, :word_relation => @attr
        end.should change(WordRelation, :count).by(1)
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @word = Factory(:word)
      @word_relation = Factory(:word_relation)
    end

    describe "success" do
      it "should delete record" do
        lambda do
          delete :destroy, :id => @word_relation
          response.code.should == "302"
          response.should redirect_to(word_path(@word))
        end.should change(WordRelation, :count).by(-1)
      end
    end
  end
end