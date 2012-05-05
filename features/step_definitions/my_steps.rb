Given /^user$/ do
  first_user
end

When /^I have word "([^"]*)"$/ do |text|
  user_word = UserWord.new
  user_word.save_with_relations(first_user, text, [], [], [])
end

Given /^I have category "([^"]*)"$/ do |name|
  UserCategory.create! :name => name, :user => first_user
end

And /^I fill login information for the first user$/ do
  user = first_user
  fill_in("session_email", :with => user.email)
  fill_in("session_password", :with => "password")
end

Given /^signed in user$/ do
  user = first_user
  visit("/signin")
  fill_in("session_email", :with => user.email)
  fill_in("session_password", :with => "password")
  click_button("Sign in")
end

Given /^word "([^"]*)" with synonym "([^"]*)"$/ do |text, synonym|
  @user_word = UserWord.new
  @user_word.save_with_relations(first_user, text, [], [synonym], [])
end

Given /^word "([^"]*)" with category "([^"]*)"$/ do |text, category|
  @user_word = UserWord.new
  @user_word.save_with_relations(first_user, text, [], [], [category])
end


Given /^word "([^"]*)" with translation "([^"]*)", synonym "([^"]*)" and category "([^"]*)"$/ do |text, translation, synonym, category|
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

When /^I wait for (\d+) seconds?$/ do |secs|
  sleep secs.to_i
end

When /^I submit the form$/ do
  page.evaluate_script("document.forms[0].submit()")
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Given /^(\d+) English words$/ do |arg|
  n = arg.to_i
  (1..n).each do
    Factory(:english_user_word)
  end
end

Given /^(\d+) Russian words$/ do |arg|
  n = arg.to_i
  (1..n).each do
    Factory(:russian_user_word)
  end
end

Then /^I should see only english words$/ do
  page.should have_content("english")
  page.should_not have_content("russian")
end

When /^I should see paginator$/ do
  page.should have_selector('div.pagination')
end