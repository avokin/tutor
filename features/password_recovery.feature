@javascript
Feature: Password recovery
  Scenario: Forgotten password
    Given user
    And I am on the root page
    And I follow "forgotten password?"
    Then I should be on reset password page
    And I fill in "email" with email of the first user
    And I submit the form
    And I wait for 1 second
    Then I should be on the login page