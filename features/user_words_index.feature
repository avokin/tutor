Feature: User words index
  Background:
    Given signed in user
    Given 40 English words
    Given 40 Russian words
    And I am on the home page

  Scenario: Paging
    Then I should see only english words

  Scenario: Filtering by language
    And I should see paginator
