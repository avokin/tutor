require 'spec_helper'

describe PagesController, :type => :controller do
  before(:each) do
    init_db
    @base_title = "Tutor"
  end

  describe "GET 'message'" do
    it "should have right title" do
      get :message
      expect(response.body).to have_title("#{@base_title} - Error")
    end
  end
end