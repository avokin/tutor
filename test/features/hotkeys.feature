@javascript
Feature: hotkyes
  Scenario: opening hotkeys
    When I am on the root page
    And I follow "Shortkey map"
    Then I should see "Search: CTRL + 'i', 's' and 'S'"

