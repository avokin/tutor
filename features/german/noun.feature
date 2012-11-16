Feature: German nouns
  Background:
    Given signed in user with target_language "Deutsch"

  Scenario: View of German Noun
    Given German Noun "Oma" with artikel "die" and plural form "Omas"
    And I am on the "Oma" word's page
    Then I should see "die"
    And I should see "Omas"
    And I should see "Nomen"

  Scenario: Edit page of German noun
    Given German Noun "Oma" with artikel "die" and plural form "Omas"
    And I am on the edit word "Oma" page
    And I should see "noun"

    Then "der" should be an option for "user_word_custom_int_field1"
    And "die" should be an option for "user_word_custom_int_field1"
    And "das" should be an option for "user_word_custom_int_field1"
    And "die" should be selected for "user_word_custom_int_field1"

    Then the "user_word_custom_string_field1" field should contain "Omas"

    Then I select "das" from "user_word_custom_int_field1"
    And I fill in "user_word_custom_string_field1" with "Kinder"
    And I press "Save word"

    Then I should be on the "Oma" word's page
    And I should see "Nomen"
    And I should see "das"
    And I should see "Kinder"

  Scenario: Creation of German noun
    When I am on the new german noun "Oma" page

    And I should see "Part of speech"
    Then "noun" should be an option for "user_word_type_id"
    And "verb" should be an option for "user_word_type_id"
    And "other" should be an option for "user_word_type_id"
    And "noun" should be selected for "user_word_type_id"

    And I should see "Gender"
    And "der" should be an option for "user_word_custom_int_field1"
    And "das" should be an option for "user_word_custom_int_field1"
    And "die" should be an option for "user_word_custom_int_field1"
    And "andere" should be an option for "user_word_custom_int_field1"

    Then I select "die" from "user_word_custom_int_field1"
    And I fill in "user_word_custom_string_field1" with "Omas"
    And I press "Save word"
    Then I should be on the "Oma" word's page
    Then I should see "die"
    And I should see "Omas"
    And I should see "Nomen"




