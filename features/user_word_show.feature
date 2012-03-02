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

  Scenario: Delete translation
    When I follow "Delete translation"
    Then I should be on the "house" word's page
    And I should not see "dom"

  Scenario: Add translation
    When I fill in
    Then I should be on the "house" word's page
    And I should not see "dom"


  Scenario: Delete synonym
    When I follow "Delete synonym"
    Then I should be on the "house" word's page
    And I should not see "building"
