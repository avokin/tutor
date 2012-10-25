@javascript
Feature: hotkyes
  Scenario: opening hotkeys
    Given signed in user
    When I am on the root page
    And I follow "Help"
    And I follow "Shortkey Map"
    Then I should see "Search: CTRL + 'i', 's' and 'S'"

