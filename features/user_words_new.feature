@javascript
Feature: New word page
  Background:
    Given signed in user

  Scenario: Creation of a new word
    When I am on the home page
    And I fill in "search_text" with "Papagei"
    And I submit the form
    And I wait for 2 seconds
    Then I should be on the new word page
    And I should see "попугай"
    And I fill in "category_0" with "animals"
    And I press "Save word"
    And I wait for 1 second
    Then I should be on the "Papagei" word's page

