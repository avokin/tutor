Feature: Login
  Scenario: Login
    Given user
    When I am on the login page
    And I fill login information for the first user
    And I press "Sign in"
    Then I should be on the user's page
    And should see "UserName UserSurname"
    And should see "Native language"
    And should see "Success count"

  Scenario: Edit user info
    Given signed in user
    When I am on user info page
    And press "Edit"
    Then I should be on edit user page
    And should see "edit name"
    And should see "edit "

  Scenario: Sign out
    Given signed in user
    And I am on the root page
    When I follow "Sign out"
    Then I should be on the login page

