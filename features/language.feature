Feature: Current language
  Background:
    Given signed in user

  @javascript
  Scenario: Change current language
    When I am on the root page
    And I should see "English"
    Then I follow "English"
    And I follow "Deutsch"
    Then I should see "Deutsch"
    Then I follow "Settings"
    And I follow "Profile"
    Then I should be on the user's profile page
    And "Deutsch" should be selected for "user_target_language_id"



