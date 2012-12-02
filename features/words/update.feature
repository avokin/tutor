Feature: Updating of a word
  Background:
    Given signed in user
    And word "parrot" with category "animals"
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