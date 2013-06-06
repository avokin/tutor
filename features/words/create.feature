Feature: Creation of a word
  Background:
    Given signed in user

  Scenario: Creation of a word
    Given default category "animals"
    Given category "plants"
    Given default category "biology"
    When I am on the new word "parrot" page
    Then I should see "animals"
    Then I should not see "plants"
    Then I should see "biology"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    Then I should see "animals"
    Then I should not see "plants"
    Then I should see "biology"

  Scenario: Adding two categories
    When I am on the new word "parrot" page
    And I fill in "category_0" with "biology, zoo"
    And I press "Save word"
    Then I should be on the "parrot" word's page
    Then I should see "biology"
    Then I should see "zoo"

  @javascript
  Scenario: Removing a category
    Given default category "animals"
    When I am on the new word "parrot" page
    Then I should see "animals"
    And I click element "span a.close"
    And I press "Save word"
    And I wait for 1 second
    Then I should be on the "parrot" word's page
    Then I should not see "animals"

  Scenario: Creating word when its translation already exists in the db
    Given word "pop" with translation "popugay"
    When I am on the new word "parrot" page
    And I press "Save word"
    Then I should be on the "parrot" word's page
    Then I should see "popugay"
