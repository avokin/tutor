require 'spec_helper'

describe UserMailer do
  before(:each) do
    init_db
    @user = FactoryBot.create(:user)
    @user.password_reset_token = 'something'
    @user.save!
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset User.first}

    it 'renders the headers' do
      expect(mail.subject).to eq('Password Reset')
      expect(mail.to).to eq([User.first.email])
      expect(mail.from).to eq(['admin@word-tutor.herokuapp.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match /^To reset your password, click/
    end
  end
end
