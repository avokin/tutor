require 'spec_helper'

describe User do
  before(:each) do
    init_db
    @attr = {:name => 'test', :email => 'test@test.com', :password => 'password'}
  end

  describe 'Password encryption' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should set encrypted password' do
      @user.encrypted_password.should_not be_blank
    end

    describe 'has_password? method' do
      it 'should accept valid password' do
        @user.has_password?(@attr[:password]).should be true
      end

      it 'should decline invalid password' do
        @user.has_password?('invalid').should be false
      end
    end

    describe 'authenticate method' do
      it 'should authenticate user' do
        User.authenticate_with_email_and_password(@attr[:email], @attr[:password]).should_not be_nil
      end

      it 'should decline user' do
        User.authenticate_with_email_and_password(@attr[:email], 'invalid').should be_nil
      end
    end

    describe 'authenticate_with_salt method' do
      it 'should authenticate user' do
        User.authenticate_with_salt(@user.id, @user.salt).should_not be_nil
      end

      it 'should decline user' do
        User.authenticate_with_email_and_password(@attr[:id], 'invalid').should be_nil
      end
    end
  end

  describe 'foreign_user_words' do
    describe "should take only words of 'target_language_id' language" do
      before(:each) do
        FactoryGirl.create(:english_user_word)
        FactoryGirl.create(:german_user_word)
      end

      it "should take only English words" do
        user = User.first
        user.foreign_user_words.length.should == 1
        user.foreign_user_words[0].language.name.should == 'English'
        user.foreign_user_words[0].text.should =~ /^english/
      end

      it 'should take only German words' do
        user = User.first
        user.target_language = Language.last

        user.foreign_user_words.length.should == 1
        user.foreign_user_words[0].language_id.should == 3
        user.foreign_user_words[0].text.should =~ /^german/
      end
    end
  end

  describe 'send_password_reset' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should send email with password recovery instructions' do
      @user.password_reset_token.should be_nil
      @user.password_reset_sent_at.should be_nil

      @email = @user.send_password_reset

      @user.password_reset_token.should_not be_nil
      @user.password_reset_sent_at.should_not be_nil

      @email.should deliver_to(@user.email)
      @email.should have_body_text(/.*#{@user.password_reset_token}.*/)
    end
  end

  describe 'update_password' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should update correct password' do
      result = @user.update_password 'password1', 'password1'
      expect(result).to be true

      User.authenticate_with_email_and_password(@user.email, 'password1').should_not be_nil
      @user.password_reset_token.should be_nil
    end

    it 'should decline incorrect password' do
      result = @user.update_password 'pass', 'pass'
      result.should be false

      User.authenticate_with_email_and_password(@user.email, 'pass').should be_nil
    end

    it 'should decline wrong confirmation' do
      result = @user.update_password 'password1', 'password2'
      result.should be false

      User.authenticate_with_email_and_password(@user.email, 'password1').should be_nil
      User.authenticate_with_email_and_password(@user.email, 'password2').should be_nil
    end
  end
end
