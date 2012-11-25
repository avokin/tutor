include UserWordsHelper

Before do
  init_db
end

Given /^user$/ do
  first_user
end

When /^I have word "([^"]*)"$/ do |text|
  FactoryGirl.create(:user_word, :text => text)
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
  @user_word = UserWord.new :user => first_user, :text => text
  @user_word.save_with_relations([], [synonym], [])
end

Given /^word "([^"]*)" with category "([^"]*)"$/ do |text, category|
  @user_word = FactoryGirl.create(:user_word, :text => text)
  @user_word.save_with_relations([], [], [category])
end

Given /^the category "([^"]*)"$/ do |name|
  @user_category = FactoryGirl.create(:user_category, :name => name)
end

Given /^word "([^"]*)" with translation "([^"]*)", synonym "([^"]*)" and category "([^"]*)"$/ do |text, translation, synonym, category|
  @user_word = FactoryGirl.create(:user_word, :text => text)
  @user_word.save_with_relations([translation], [synonym], [category])
end

Given /^word "([^"]*)" with translations "([^"]*)", "([^"]*)"$/ do |text, translation1, translation2|
  @user_word = FactoryGirl.create(:user_word, :text => text)
  @user_word.save_with_relations([translation1, translation2], [], [])
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
    FactoryGirl.create(:english_user_word)
  end
end

Given /^(\d+) Russian words$/ do |arg|
  n = arg.to_i
  (1..n).each do
    FactoryGirl.create(:russian_user_word)
  end
end

Then /^I should see only english words$/ do
  page.should have_content("english")
  page.should_not have_content("russian")
end

When /^I should see paginator$/ do
  page.should have_selector('div.pagination')
end

When /^I fill in "([^"]*)" with email of the first user$/ do |field|
  fill_in(field, :with => User.first.email)
end

When /^The User should receive an email$/ do
  step "\"#{User.first.email}\" should receive an email"
end

When /^I check default checkbox for user category "([^"]*)"$/ do |category_name|
  category = UserCategory.find_by_name category_name
  step "I check \"chkDefault_#{category.id}\""
end

When /^Checkbox default for user category "([^"]*)" should be checked$/ do |category_name|
  category = UserCategory.find_by_name category_name
  find("#chkDefault_#{category.id}").should be_checked
end

When /^I simulate waiting for (\d+) hours$/ do |hourse|
  user = User.first
  user.password_reset_sent_at = 3.hours.ago
  user.save!
end

When /^I fill wrong login information for the first user$/ do
  user = first_user
  fill_in("session_email", :with => user.email)
  fill_in("session_password", :with => "password2")
end

Given /^German Noun "([^"]*)" with artikel "([^"]*)" and plural form "([^"]*)"$/ do |text, artikel, plural_form|
  gender_id = get_german_gender_by_artikel(artikel)
  FactoryGirl.create(:german_user_word, :text => text, :type_id => 2, :custom_int_field1 => gender_id, :custom_string_field1 => plural_form)
end

When /^My target language is "([^"]*)"$/ do |language_name|
  user = User.first
  language = Language.find_by_name(language_name)
  user.update_attributes(:language => language)
end

Given /^signed in user with target_language "([^"]*)"$/ do |language|
  user = FactoryGirl.create(:user, :target_language => Language.find_by_name("Deutsch"))
  visit("/signin")
  fill_in("session_email", :with => user.email)
  fill_in("session_password", :with => "password")
  click_button("Sign in")
end

When /^I have training for category (.*)$/ do |category|
  FactoryGirl.create(:training, :user_category => UserCategory.find_by_name(category))
end

Then /^I should see first letter of (.*)$/ do |word|
  step "I should see \"#{word[0, 1]}\""
end

Given /^(default )?category "([^"]*)"$/ do |is_default, category_name|
  FactoryGirl.create(:user_category, :name => category_name, :is_default => !is_default.nil?)
end