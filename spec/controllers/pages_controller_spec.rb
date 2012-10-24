require 'spec_helper'

describe PagesController, :type => :controller do
  #render_views

  before(:each) do
    @base_title = "Tutor"
  end

  describe "GET 'message'" do
    it "should have right title" do
      get :message
      response.should have_selector("title", :content => "#{@base_title} - Error")
    end
  end
end