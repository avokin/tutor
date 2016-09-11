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
      expect(@user.encrypted_password).not_to be_blank
    end

    describe 'has_password? method' do
      it 'should accept valid password' do
        expect(@user.has_password?(@attr[:password])).to be true
      end

      it 'should decline invalid password' do
        expect(@user.has_password?('invalid')).to be false
      end
    end

    describe 'authenticate method' do
      it 'should authenticate user' do
        expect(User.authenticate_with_email_and_password(@attr[:email], @attr[:password])).not_to be_nil
      end

      it 'should decline user' do
        expect(User.authenticate_with_email_and_password(@attr[:email], 'invalid')).to be_nil
      end
    end

    describe 'authenticate_with_salt method' do
      it 'should authenticate user' do
        expect(User.authenticate_with_salt(@user.id, @user.salt)).not_to be_nil
      end

      it 'should decline user' do
        expect(User.authenticate_with_email_and_password(@attr[:id], 'invalid')).to be_nil
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
        expect(user.foreign_user_words.length).to eq 1
        expect(user.foreign_user_words[0].language.name).to eq 'English'
        expect(user.foreign_user_words[0].text).to match /^english/
      end

      it 'should take only German words' do
        user = User.first
        user.target_language = Language.last

        expect(user.foreign_user_words.length).to eq 1
        expect(user.foreign_user_words[0].language_id).to eq 3
        expect(user.foreign_user_words[0].text).to match /^german/
      end
    end
  end

  describe 'send_password_reset' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should send email with password recovery instructions' do
      expect(@user.password_reset_token).to be_nil
      expect(@user.password_reset_sent_at).to be_nil

      @email = @user.send_password_reset

      expect(@user.password_reset_token).to_not be_nil
      expect(@user.password_reset_sent_at).to_not be_nil

      expect(@email).to deliver_to(@user.email)
      expect(@email).to have_body_text(/.*#{@user.password_reset_token}.*/)
    end
  end

  describe 'update_password' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should update correct password' do
      result = @user.update_password 'password1', 'password1'
      expect(result).to be true

      expect(User.authenticate_with_email_and_password(@user.email, 'password1')).to_not be_nil
      expect(@user.password_reset_token).to be_nil
    end

    it 'should decline incorrect password' do
      result = @user.update_password 'pass', 'pass'
      expect(result).to be false

      expect(User.authenticate_with_email_and_password(@user.email, 'pass')).to be_nil
    end

    it 'should decline wrong confirmation' do
      result = @user.update_password 'password1', 'password2'
      expect(result).to be false

      expect(User.authenticate_with_email_and_password(@user.email, 'password1')).to be_nil
      expect(User.authenticate_with_email_and_password(@user.email, 'password2')).to be_nil
    end
  end
end
