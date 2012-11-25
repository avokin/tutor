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
