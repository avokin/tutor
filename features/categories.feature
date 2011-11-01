@javascript
Feature: categories
  Scenario: category list viewing
    Given signed in user
    Given word "home" with category "life"
    And I am on the root page
    And I follow "Categories"
    And I should see "life"
    And I follow "life"
    Then I should be on the "life" category page
    And I should see "home"
