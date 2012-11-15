@javascript
Feature: Searching for german words
  Scenario: Searching a German Noun
    Given signed in user with target_language "Deutsch"
    When My target language is "Deutsch"
    When I am on the home page
    And I fill in the following:
      | search_text    | Kind |
    And I submit the form
    And I wait for 2 second

    Then I should be on the new word page
    And I should see "Kind"

    And "noun" should be selected for "user_word_type_id"
    And "das" should be selected for "user_word_custom_int_field1"
    And the "user_word_custom_string_field1" field should contain "Kinder"