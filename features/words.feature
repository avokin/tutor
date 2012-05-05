@javascript
Feature: UserWord's page
  Scenario Outline: Autocompletion in the category field
    Given signed in user
    When I have word "<word>"
    When I have category "<category>"
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