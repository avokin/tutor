module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
      when /^the home\s?page$/
        '/'
      when /^the login page$/
        "/signin"
      when /^the word\'s page$/
        "/user_words/1"
      when /^the "([^"]*)" word's page$/
        user_word = UserWord.find_for_user(User.first, $1)
        user_word_path user_word
      when /^the edit word "([^"]*)" page$/
        user_word = UserWord.find_for_user(User.first, $1)
        edit_user_word_path user_word
      when /^the "([^"]*)" category's page$/
        user_category = UserCategory.find_by_user_and_name(User.first, $1)
        user_category_path user_category
      when /^the new word page$/
        "/user_words/new"
      when /^the new german noun "([^"]*)" page$/
        "/user_words/new?text=#{$1}&type_id=2"
      when /^the user\'s page$/
        "/users/1"
      when /^start learning page$/
        "/tries"
      when /^learning page$/
        "/tries/1"
      when /^the "([^"]*)" category page$/
        user_category_path UserCategory.find_by_name($1)
      when /^the edit "([^"]*)" category page$/
        edit_user_category_path UserCategory.find_by_name($1)
      when /^the categories page$/
        user_categories_path
      when /^reset password page$/
        new_password_reset_path
      when /^the new password page$/
        edit_password_reset_path User.first.password_reset_token
      when /^the user\'s profile page$/
        user_path User.first
      when /^the create category page$/
        new_user_category_path
      else
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)
