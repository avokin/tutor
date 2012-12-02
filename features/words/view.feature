Feature: Updating of a word
  Background:
    Given signed in user
    And word "parrot" with category "animals"
    And I am on the "parrot" word's page

  Scenario: Adding one category
    Then I should see "animals"
    And I fill in "category_0" with "biology"
    And I press "add_category"
    Then I should be on the "parrot" word's page
    And I should see "animals"
    And I should see "biology"
