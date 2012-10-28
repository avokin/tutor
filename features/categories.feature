Feature: categories
  Scenario: creation of UserCategory
    Given signed in user
    And I have word "test"
    And I am on the "test" word's page
    And I fill in "category_0" with "new_category"
    And I press "add_category"
    Then I should be on the "test" word's page
    And I should see "new_category"

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
    And I press "Delete"
    Then I should be on the categories page
    And I should not see "life"

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

  Scenario: Updating the category
    Given signed in user
    Given the category "life"
    And I am on the "life" category page
    Then I should see "life"
    And I follow "Edit"
    Then I should be on the edit "life" category page
    And I fill in "user_category_name" with "changed_life"
    And I check "user_category_is_default"
    And I press "Update"
    And I should be on the "changed_life" category page
    And I should see "(default)"

  Scenario: Canceling edition of the category
    Given signed in user
    Given the category "life"
    And I am on the "life" category page
    Then I should see "life"
    And I follow "Edit"
    Then I should be on the edit "life" category page
    And I fill in "user_category_name" with "changed_life"
    And I check "user_category_is_default"
    And I press "Cancel"
    And I should be on the "life" category page
    And I should not see "(default)"

  @javascript
  Scenario: default category
    Given signed in user
    Given the category "life"
    And I am on the root page
    And I follow "Categories"
    And I wait for 1 second
    Then I should be on the categories page
    And I should see "life"
    And I check default checkbox for user category "life"
    Then I am on the root page
    And I follow "Categories"
    Then I should be on the categories page
    And Checkbox default for user category "life" should be checked


