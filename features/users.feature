Feature: Users
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


