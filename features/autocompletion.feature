@javascript
Feature: Autocompletion
  Scenario: Autocompletion in the search field
    Given signed in user
    When word "alpha"
    When word "betta"
    And I go to the home page
    And I fill in "search_word" with "al"
    And I choose "alpha" in the autocomplete list
    Then the "search_word" field should contain "alpha"