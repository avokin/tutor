Feature: Updating of a word
  Background:
    Given signed in user
    And word "parrot" with translation "popugay", synonym "bird" and category "animals"
    And I am on the "parrot" word's page

  Scenario: Adding one category
    Then I should see "animals"
    And I fill in "category_0" with "biology"
    And I press "add_category"
    Then I should be on the "parrot" word's page
    And I should see "animals"
    And I should see "biology"

  Scenario: Adding translation through show page
    Then I fill in "translation_0" with "popka"
    And I press "Add"
    Then I should see "popka"
    Then I should see "popugay"

  Scenario: Adding synonym through show page
    Then I fill in "synonym_0" with "ptica"
    And I press "Add"
    Then I should see "ptica"
    Then I should see "bird"
