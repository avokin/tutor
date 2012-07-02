@javascript
Feature: Search
  Scenario Outline: Searching a word that exist
    Given signed in user
    When I have word "<word>"
    When I am on the home page
    And I fill in the following:
      | search_word    | <word> |
    And I submit the form
    Then I should be on the word's page
    And should see "<word>"
    And I fill in the following:
      | translation_0 | new translation|
      | synonym_0     | new synonym    |
  Examples:
    | word         |
    | existed word |

  Scenario: Searching a word that doesn't exist
    Given signed in user
    When I am on the home page
    And I fill in the following:
      | search_word    | new word1 |
    And I submit the form
    Then I should be on the new word page
