Feature: Users
  Scenario: Successful signing up
    When I am on the signup page
    And I fill in "user_name" with "Test User"
    And I fill in "user_email" with "email@gmail.com"
    And I fill in "user_password" with "super_password"
    And I fill in "user_password_confirmation" with "super_password"
    And I press "Sign up"
    And I should be on the user's profile page

  Scenario: Edit user info
    Given signed in user
    When I am on the user's profile page
    And should see "Native Language"
    And should see "Target Language"
    And I select "Deutsch" from "user_target_language_id"
    And I press "Save"
    Then I should be on the user's profile page
    And I should see "Deutsch"
    And I select "English" from "user_target_language_id"
    And I press "Save"
    Then I should be on the user's profile page
    And I should see "English"


