Feature: Session
  Scenario: Sign in
    Given user
    When I am on the root page
    And I fill login information for the first user
    And I press "Sign in"
    Then I should be on the user's page
    And should see "UserName UserSurname"
    And should see "Native Language"
    And should see "Success Count"

  Scenario: Sign out
    Given signed in user
    And I am on the root page
    When I follow "Sign out"
    Then I should be on the login page

  Scenario Outline: Restricted access to pages that require authentication
    Given word "house" with translation "dom", synonym "building" and category "life"
    When I am on <page>
    Then I should be on the login page
  Examples:
    | page                       |
    | the root page              |
    | the "house" word's page    |
    | the "life" category's page |

