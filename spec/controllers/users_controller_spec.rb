require 'spec_helper'

describe UsersController, :type => :controller do
  before(:each) do
    init_db
  end

  describe "POST 'create'" do
    before(:each) do
      init_db
    end

    describe 'failure' do
      before(:each) do
        @attr = {:name => '', :email => '', :password => '', :password_confirmation => ''}
      end

      it "shouldn't create user" do
        expect do
          post :create, :user => @attr
        end.to_not change(User, :count)

        expect(response).to render_template('new')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = {:name => 'test', :email => 'test@test.com', :password => 'simple', :password_confirmation => 'simple'}
      end

      it 'should create user' do
        expect do
          post :create, :user => @attr
        end.to change(User, :count).by(1)
        expect(controller).to be_signed_in
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @attributes = {:native_language_id => 3, :success_count => 10}
      test_sign_in(@user)
    end

    it 'should have right title' do
      get :edit, :id => @user.id
      expect(response.body).to have_title('Tutor - Edit Account')
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @attributes = {:success_count => 10, :native_language_id => 3, :target_language_id => 2}
    end

    describe "Authorized user can edit it's own settings" do
      before(:each) do
        test_sign_in @user
      end

      it 'should change Users attributes' do
        put :update, :id => @user.id, :user => @attributes
        @user.reload
        expect(@user.success_count).to eq @attributes[:success_count]
        expect(@user.native_language_id).to eq @attributes[:native_language_id]
      end
    end

    describe "Not authorized user can't edit settings" do
      it "should not change user's attributes" do
        put :update, :id => @user.id, :user => @attributes
        expect(response).to redirect_to signin_path

        success_count = @user.success_count
        native_language_id = @user.native_language_id
        @user.reload
        expect(@user.success_count).to eq success_count
        expect(@user.native_language_id).to eq native_language_id
      end
    end
  end
end
