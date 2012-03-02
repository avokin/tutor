@javascript
Feature: learning
  Scenario: synonyms learning
    Given signed in user
    Given word "house" with synonym "building"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I select "synonyms" from "tries_targeting"
    And I select "learning" from "tries_mode"
    And I press "Start"
    Then I should be on learning page
    And I should see "house"
    And I follow "Learning"
    Then I should be on start learning page
    And I select "translations" from "tries_targeting"
    And I select "learning" from "tries_mode"
    And I press "Start"
    Then I should see "error"

  Scenario: repetition
    Given signed in user
    And learned translation
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page

  Scenario: learning, correct answer
    Given signed in user
    Given word "house" with translation "dom", synonym "home" and category "everyday life"
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
    Given word "house" with translation "dom", synonym "home" and category "everyday life"
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

  Scenario: learning, one "hint" button press
    Given signed in user
    Given word "house" with translation "zdanie", synonym "home" and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I should not see "zda"
    And I press "Hint"
    Then I should be on learning page
    Then I should see "zda"
    Then the "answer" field should be ""
    And I fill in the following:
      | answer | zdanie |
    And I press "Check"
    And I should see "Success"
    And Success count should increase

  Scenario: learning, two "hint" button press
    Given signed in user
    Given word "house" with translation "zdanie", synonym "home" and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I should not see "zda"
    And I press "Hint"
    Then I should be on learning page
    Then I should see "zda"
    Then the "answer" field should be ""
    And I press "Hint"
    Then I should see "zdanie"
    Then the "answer" field should be ""
    And I fill in the following:
      | answer | zdanie |
    And I press "Check"
    And I should not see "Success"
    And I should not see "Wrong"
    And Success count should zero

  Scenario: learning, skip
    Given signed in user
    Given word "house" with translation "zdanie", synonym "home" and category "everyday life"
    And I am on the root page
    And I follow "Learning"
    Then I should be on start learning page
    And I press "Start"
    Then I should be on learning page
    And I should not see "zdanie"
    And I press "Skip"
    Then I should see "zdanie"
    Then the "answer" field should be ""
    And I wait for 2 seconds
    Then I should be on learning page
    And I should not see "Success"
    And I should not see "Wrong"
    And Success count should zero
