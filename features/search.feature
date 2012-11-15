@javascript
Feature: Search
  Background:
    Given signed in user

  Scenario Outline: Searching a word that exist
    When I have word "<word>"
    When I am on the home page
    And I fill in the following:
      | search_text    | <word> |
    And I submit the form
    And I wait for 1 second
    Then I should be on the word's page
    And should see "<word>"
    And I fill in the following:
      | translation_0 | new translation|
      | synonym_0     | new synonym    |
  Examples:
    | word         |
    | existed word |

  Scenario: Searching a word that doesn't exist
    When I am on the home page
    And I fill in the following:
      | search_text    | new word1 |
    And I submit the form
    And I wait for 1 second
    Then I should be on the new word page
