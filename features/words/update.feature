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
    And I wait for 1 second
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

  Scenario: Adding and removing translation through edit page
    Then I fill in "translation_0" with "popka"
    And I press "Save word"
    Then I should see "popka"
    And I should see "popugay"
    And I am on the edit word "parrot" page
    Then I uncheck "translation_1"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    And I should not see "popugay"
    And I should see "popka"


  Scenario: Adding synonym through edit page
    Then I fill in "synonym_0" with "small bird"
    And I press "Save word"
    Then I should see "small bird"
    Then I should see "bird"

