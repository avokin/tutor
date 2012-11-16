@javascript
Feature: Training
  Scenario Outline: Successful attempt
    Given signed in user
    And word "<word>" with translation "<translation>", synonym "" and category "<category>"
    And I have training for category <category>
    And I am on the trainings page
    And I press "Start"
    Then I should be on the training page
    And the "answer0" field should contain ""
    Then I fill in "answer0" with "<translation>"
    And press "Check"
    Then I should be on the training page
    And I should see "There are no ready words in the current training"
  Examples:
    | word  | translation | category |
    | house | dom         | live     |

  Scenario Outline: Incorrect attempt
    Given signed in user
    And word "<word>" with translation "<translation>", synonym "" and category "<category>"
    And I have training for category <category>
    And I am on the trainings page
    And I press "Start"
    Then I should be on the training page
    And the "answer0" field should contain ""
    Then I fill in "answer0" with "<incorrect_attempt>"
    And press "Check"
    Then I should be on the training page
    And the "answer0" field should contain "<incorrect_attempt>"
    And I should not see "There are no ready words in the current training"
  Examples:
    | word  | translation | incorrect_attempt | category |
    | house | dom         | wrong             | live     |

  Scenario Outline: Calling for a hint
    Given signed in user
    And word "<word>" with translation "<translation>", synonym "" and category "<category>"
    And I have training for category <category>
    And I am on the trainings page
    And I press "Start"
    Then I should be on the training page
    And the "answer0" field should contain ""
    And I press "Hint"
    Then I should see first letter of <translation>
    Then I should not see "<translation>"
    And I press "Hint"
    Then I should see "<translation>"
  Examples:
    | word  | translation | category |
    | house | dom         | live     |
