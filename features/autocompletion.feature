@javascript
Feature: Autocompletion
  Scenario: Autocompletion in the search field
    Given signed in user
    When I have word "alpha"
    When I have word "betta"
    And I go to the home page
    And I fill in "search_text" with "al"
    And I choose "alpha" in the autocomplete list
    Then the "search_text" field should contain "alpha"