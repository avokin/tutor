@javascript
Feature: learning
  Scenario: learning, correct answer
    Given signed in user
    Given word "house" with translation "dom", synonym "home", and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I fill in the following:
      | answer | dom |
    And I press "Check"
    Then I should be on learning page
    And I should see "Success"
    And Success count should increase

  Scenario: learning, user inputs another translation
    Given signed in user
    Given word "house" with translations "dom", "zdanie"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I fill in the following:
      | answer | zdanie |
    And I press "Check"
    Then I should be on learning page
    And I should see "Another"
    And Success count should zero


  Scenario: learning, wrong answer
      Given signed in user
      Given word "house" with translation "dom", synonym "home", and category "everyday life"
      And I am on the root page
      And I follow "Learning"
      Then I should be on start learning page
      And I press "Start"
      Then I should be on learning page
      And I fill in the following:
        | answer | wrong |
      And I press "Check"
      Then I should be on learning page
      And I should see "Wrong"
      And Success count should zero