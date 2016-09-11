require 'spec_helper'

describe WordRelationsController, :type => :controller do
  before(:each) do
    init_db
  end

  describe "POST 'create'" do
    before(:each) do
      user = FactoryGirl.create(:user)
      test_sign_in(user)
      @user_word = FactoryGirl.create(:english_user_word)
    end

    describe "fail" do
      describe "fail if incorrect relation type" do
        before(:each) do
          @attr = {:user_word_id => @user_word.id, :related_word => 'related_word', :relation_type => "0"}
        end

        it "should fail because of non-existed word" do
          expect do
            post :create, :word_relation => @attr
          end.to_not change(WordRelation, :count)
          expect(response).to render_template('pages/message')
        end
      end

      describe "fail if can't save relation'" do
        before(:each) do
          @attr = {:user_word_id => @user_word.id, :related_word => nil, :relation_type => "1"}
        end

        it 'should fail because of empty related word' do
          expect do
            post :create, :word_relation => @attr
          end.to_not change(WordRelation, :count)
          expect(response).to render_template('pages/message')
        end
      end
    end

    describe 'success' do
      before(:each) do
        @attr = {:user_word_id => @user_word.id, :related_word => 'related_word', :relation_type => "1"}
      end

      it 'should create a new Word and a new WordRelation' do
        expect do
          post :create, :word_relation => @attr
        end.to change(WordRelation, :count).by(1)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @word_relation = FactoryGirl.create(:word_relation_translation)
    end

    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          delete :destroy, :id => @word_relation
          expect(response).to redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = FactoryGirl.create(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          delete :destroy, :id => @word_relation
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @word_relation.user
      end

      it "should delete record" do
        expect do
          delete :destroy, :id => @word_relation
          expect(response.code).to eq "302"
          expect(response).to redirect_to(user_word_path(@word_relation.source_user_word))
        end.to change(WordRelation, :count).by(-1)
      end
    end
  end

  describe "DELETE 'destroy_with_related_word'" do
    before(:each) do
      @word_relation = FactoryGirl.create(:word_relation_translation)
    end

    describe "unauthorized access" do
      describe "not logged in user" do
        it "should redirect to signin path" do
          delete :destroy_with_related_word, :id => @word_relation.id
          expect(response).to redirect_to signin_path
        end
      end

      describe "not owner user" do
        before(:each) do
          user = FactoryGirl.create(:user)
          test_sign_in user
        end

        it "should redirect to root path and display flash with error" do
          delete :destroy_with_related_word, :id => @word_relation.id
          expect(response).to redirect_to root_path
          expect(flash[:error]).to match /Error.*another user/
        end
      end
    end

    describe "authorized access" do
      before(:each) do
        test_sign_in @word_relation.user
      end

      it "should delete related UserWord and WordRelation itself" do
        expect do
          expect do
            delete :destroy_with_related_word, :id => @word_relation.id
          end.to change(UserWord, :count).by(-1)
        end.to change(WordRelation, :count).by(-1)

        expect(UserWord.find_by(id: @word_relation.related_user_word.id)).to be_nil
      end
    end
  end
end