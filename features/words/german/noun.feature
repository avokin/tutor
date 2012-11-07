Feature: German nouns
  Scenario: View of German Noun
    Given German Noun "Oma"
    And I am on the "Oma" word's page
    Then I should see "die"
    And I should see "Omas"
    And I should see "noun"

  Scenario: Edit page of German noun
    Given German Noun "Oma"
    And I am on the edit word "Oma" page
    And I should see "noun"

    Then "der" should be an option for "german_noun_gender"
    And "die" should be an option for "german_noun_gender"
    And "das" should be an option for "german_noun_gender"
    And "die" should be selected for "german_noun_gender"

    And I should see "Omas"

    Then I fill in "german_noun_gender" with "das"
    And I fill in "user_word_text" with "Kind"
    And I fill in "german_noun_plural" with "-er (Kinder)"
    And I press "Save"

    Then I should be on the page of word "Kind"
    And I should see "noun"
    And I should see "das"
    And I should see "-er (Kinder)"

  Scenario: Creation of German noun
    When I am on the new word page

    Then "noun" should be an option for "german_part_of_speech"
    And "verb" should be an option for "german_part_of_speech"
    And "other" should be an option for "german_part_of_speech"
    And "noun" should be selected for "german_part_of_speech"
    And I should see "gender"

    And I fill in "user_word_text" with "Oma"
    Then I fill in "german_noun_gender" with "das"
    And I fill in "german_noun_plural" with "Omas"
    And I press "Save"
    Then I should be on the "Oma" word's page
    Then I should see "die"
    And I should see "Omas"
    And I should see "noun"




