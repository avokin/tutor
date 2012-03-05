Feature: User words index
  Background:
    Given signed in user
    Given 40 Russian words
    Given 40 English words
    And I am on the home page

  Scenario: Paging
    And I should see paginator

  Scenario: Filtering by language
    Then I should see only english words
