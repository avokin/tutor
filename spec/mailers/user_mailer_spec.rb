require "spec_helper"

describe UserMailer do
  before(:each) do
    FactoryGirl.create(:user)
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset User.first}

    it "renders the headers" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([User.first.email])
      mail.from.should eq(["admin@word-tutor.herokuapp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should =~ /^To reset your password, click/
    end
  end

end
