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
