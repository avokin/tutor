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
      when /^the new word page$/
        "/user_words/new"
      when /^the user\'s page$/
        "/users/1"
      when /^start learning page$/
        "/tries"
      when /^learning page$/
        "/tries/1"
      when /^the "([^"]*)" category page$/
        "/user_categories/1"
      when /^the categories page$/
        "/user_categories"
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
