Feature: Updating of a word
  Background:
    Given signed in user
    And word "parrot" with translation "popugay", synonym "bird" and category "animals"
    And I am on the edit word "parrot" page

  @javascript
  Scenario: Removing a category and adding two
    Then I should see "animals"
    And I click element "span a.close"
    And I fill in "category_0" with "biology,zoo"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    And I should not see "animals"
    And I should see "biology"
    And I should see "zoo"

  Scenario: Adding one category
    Then I should see "animals"
    And I fill in "category_0" with "biology"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    And I should see "biology"

  Scenario: Removing translation
    Then I should see "popugay"
    Then I uncheck "translation_1"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    And I should not see "popugay"

  Scenario: Removing synonym
    Then I should see "bird"
    Then I uncheck "synonym_1"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    And I should not see "bird"
