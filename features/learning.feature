@javascript
Feature: learning
  Scenario: synonyms learning
    Given signed in user
    Given word "house" with synonym "building"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I fill in the following:
      | tries_targeting | synonyms |
      | tries_mode      | learning |
    And I press "Start"
    Then I should be on learning page
    And I should see "house"
    And I follow "Learning"
    Then I should be on start learning page
    And I fill in the following:
      | tries_targeting | translations |
      | tries_mode      | learning |
    And I press "Start"
    Then I should be on error page

  Scenario: repetition
    Given signed in user
    And learned translation
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page


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

  Scenario: learning, hint
    Given signed in user
    Given word "house" with translation "zdanie", synonym "home", and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I should not see "zda"
    And I press "Hint"
    Then I should be on learning page
    Then the "answer" field should be "zda"

  Scenario: learning, skip
    Given signed in user
    Given word "house" with translation "zdanie", synonym "home", and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I should not see "zdanie"
    And I press "Skip"
    Then the "answer" field should be "zdanie"
    Then I should be on learning page
    And Success count should zero
