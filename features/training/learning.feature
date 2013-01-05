Feature: Training
  Scenario Outline: Successful attempt
    Given signed in user
    And word "<word1>" with translation "<translation1>", synonym "" and category "<category>"
    And word "<word2>" with translation "<translation2>", synonym "" and category "<category>"
    And I have training for category <category>
    And I am on the trainings page
    And I press "Learn"
    Then I should be on the learning page
    And I should see "<word1>"
    And I should see "<translation1>"
    And I should see "<word2>"
    And I should see "<translation2>"
  Examples:
    | word1 | translation1 | word2  | translation2| category |
    | house | dom          | parrot | popugay     | live     |
