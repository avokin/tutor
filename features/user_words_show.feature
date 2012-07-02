Feature: User word's page
  Background:
    Given signed in user
    Given word "house" with translation "dom", synonym "building" and category "life"
    And I am on the "house" word's page

  Scenario: Checking content of user word's page
    Then I should see "dom"
    And I follow "dom"
    Then I should be on the "dom" word's page
    Then I am on the "house" word's page
    Then I should see "building"
    And I follow "building"
    Then I should be on the "building" word's page
    Then I am on the "house" word's page
    Then I should see "life"
    And I follow "life"
    Then I should be on the "life" category's page

  Scenario: Progress bar of the user word
    Then I should see "dom"
    And the page should have tag "div" with attribute "style" with value "width: 0%"

  Scenario: Add translation
    And I fill in the following:
      | translation_0 | zdanie |
    And I press "add_translation"
    Then I should be on the "house" word's page
    And I should see "zdanie"

  Scenario: Delete translation
    When I follow "Delete translation"
    Then I should be on the "house" word's page
    And I should not see "dom"

  Scenario: Delete translation word
    When I follow "Delete word 'dom'"
    Then I should be on the "house" word's page
    And I should not see "dom"

  Scenario: Add synonym
    And I fill in the following:
      | translation_0 | appartment |
    And I press "add_synonym"
    Then I should be on the "house" word's page
    And I should see "appartment"

  Scenario: Delete synonym
    When I follow "Delete synonym"
    Then I should be on the "house" word's page
    And I should not see "building"

  Scenario: Delete synonym word
    When I follow "Delete word 'building'"
    Then I should be on the "house" word's page
    And I should not see "building"

  Scenario: Add category
      And I fill in the following:
        | category_0 | construction |
      And I press "add_category"
      Then I should be on the "house" word's page
      And I should see "construction"

  Scenario: Delete category
    When I follow "×"
    Then I should be on the "house" word's page
    And I should not see "life"

  Scenario: Reset learn status
    When I press "Reset"
    Then I should be on the "house" word's page

