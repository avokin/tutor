Given /^user$/ do
  first_user
end

When /^word "([^"]*)"$/ do |text|
  user_word = UserWord.new
  user_word.save_with_relations(first_user, text, [], [], [])
end


Given /^signed in user$/ do
  user = first_user
  visit("/signin")
  fill_in("session_email", :with => user.email)
  fill_in("session_password", :with => user.password)
  click_button("Sign in")
end

Given /^word "([^"]*)" with synonym "([^"]*)"$/ do |text, synonym|
  @user_word = UserWord.new
  @user_word.save_with_relations(first_user, text, [], [synonym], [])
end

Given /^word "([^"]*)" with translation "([^"]*)", synonym "([^"]*)", and category "([^"]*)"$/ do |text, translation, synonym, category|
  @user_word = UserWord.new
  @user_word.save_with_relations(first_user, text, [translation], [synonym], [category])
end

Given /^word "([^"]*)" with translations "([^"]*)", "([^"]*)"$/ do |text, translation1, translation2|
  @user_word = UserWord.new
  @user_word.save_with_relations(first_user, text, [translation1, translation2], [], [])
end


When /^Success count should (increase|zero)$/ do |success_count|
  if success_count == "increase"
    @user_word.translations[0].success_count.should == 1
  else
    @user_word.translations[0].success_count.should == 0
  end
end

Then /^the "([^"]*)" field should be "([^"]*)"$/ do |id, value|
  field = find("##{id}")
  field.value.should == value
end