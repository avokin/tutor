@javascript
Feature: UserWord's page
  Scenario: Creation of a new word
    Given signed in user
    When I am on the home page
    And I fill in the following:
      | search_text    | parrot |
    And I submit the form
    And I wait for 1 second
    Then I should be on the new word page
    And I should see "popugay"
    And I should see "kakadu"
    Then I uncheck "translation_1"
    And check "translation_2"
    And I fill in "translation_0" with "ptica"
    And I fill in "user_word_comment" with "my comment"
    And I press "Save word"
    And I wait for 1 second
    Then I should be on the "parrot" word's page
    And I should see "kakadu"
    And I should see "ptica"
    And I should see "my comment"
    And I should not see "popugay"

  Scenario Outline: Autocompletion in the category field
    Given signed in user
    When I have word "<word>"
    Given the category "<category>"
    And I go to the "<word>" word's page
    And I fill in "category_0" with "an"
    And I choose "<category>" in the autocomplete list
    Then the "category_0" field should contain "<category>"
  Examples:
    | word | category |
    | wolf | animals  |



#add translation
#add synonym
#add category
#remove translation
#remove synonym
#remove category

#rename word