Feature: Login

  Scenario: Edit user info
    Given signed in user
    When I am on user info page
    And press "Edit"
    Then I should be on edit user page
    And should see "edit name"
    And should see "edit "


