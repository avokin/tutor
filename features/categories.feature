Feature: categories
  Scenario: category list viewing
    Given signed in user
    Given word "home" with category "life"
    And I am on the root page
    And I follow "Categories"
    Then I should be on the categories page
    And I should see "life"
    And I follow "life"
    Then I should be on the "life" category page
    And I should see "home"

  Scenario: deleting of a category
    Given signed in user
    Given word "home" with category "life"
    And I am on the root page
    And I follow "Categories"
    Then I should be on the categories page
    And I should see "life"
    And I follow "x"
    Then I should be on the categories page
    Then I am on the root page
    And I should see "home"

  Scenario: unlinking of a category
    Given signed in user
    Given word "home" with category "life"
    And I am on the word's page
    Then I should see "life"
    And I follow "×"
    Then I should be on the word's page
    And I should not see "life"
    When I am on the root page
    And I follow "Categories"
    Then I should see "life"

  Scenario: default category
    Given signed in user
    Given word "home" with category "life"
    And I am on the root page
    And I follow "Categories"
    Then I should be on the categories page
    And I should see "life"
    #And I check "life"


