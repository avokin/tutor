@javascript
Feature: Main menu items
  Scenario: Hotkeys
    Given signed in user
    When I am on the root page
    And I follow "Help"
    And I follow "Shortkey Map"
    Then I should see "Search: CTRL + 'i', 's' and 'S'"

  Scenario: User's profile
    Given signed in user
    When I am on the root page
    And I follow "Settings"
    And I follow "Profile"
    Then I should be on the user's profile page
    And I should see "Native Language"
    And I should see "Target Language"
