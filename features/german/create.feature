Feature: German word creation
  Background:
    Given signed in user with target_language "Deutsch"

  @javascript
  Scenario: Creation of German noun
    When I am on the new german noun "Oma" page
    And I should see "Part of speech"
    Then "noun" should be an option for "user_word_type_id"
    And "verb" should be an option for "user_word_type_id"
    And "other" should be an option for "user_word_type_id"
    And "noun" should be selected for "user_word_type_id"
    And I should see "Gender"
    When I select "other" from "user_word_type_id"
    And I wait for 2 second
    And "other" should be selected for "user_word_type_id"
    And I should not see "Gender"

  Scenario: Replacing encoded umlauts
    When I am on the new german noun "Getraenk" page
    And I should see "Getränk"

