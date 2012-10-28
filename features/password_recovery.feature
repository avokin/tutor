Feature: Password recovery
  Background:
    Given user
    And I am on the root page
    And I follow "forgotten password?"
    Then I should be on reset password page

  Scenario: Forgotten password. Correct scenario. And duplicate recovery attempt
    And I fill in "email" with email of the first user
    And I press "Reset Password"
    Then I should be on the login page
    And I should see "Email sent with password reset instructions."
    And The User should receive an email
    When I open the email
    And I should see "To reset your password, click the URL below." in the email body
    When I click the first link in the email
    Then I should be on the new password page
    Then I fill in "user_password" with "password"
    Then I fill in "user_password_confirmation" with "password"
    And I press "Update Password"
    Then I should be on the login page
    And I should see "Password has been reset!"
    And I fill login information for the first user
    And I press "Sign in"
    Then I should be on the user's page
    When I click the first link in the email
    Then I should be on the login page
    And I should see "Recovery token is incorrect or expired"


  Scenario: Forgotten password. Incorrect email
    And I fill in "email" with "non-existed@gmail.com"
    And I press "Reset Password"
    Then I should be on reset password page
    And I should see "Not registered user"

  Scenario: Forgotten password. Incorrect password confirmation
    And I fill in "email" with email of the first user
    And I press "Reset Password"
    Then I should be on the login page
    And I should see "Email sent with password reset instructions."
    And The User should receive an email
    When I open the email
    And I should see "To reset your password, click the URL below." in the email body
    When I click the first link in the email
    Then I should be on the new password page
    Then I fill in "user_password" with "password"
    Then I fill in "user_password_confirmation" with "password2"
    And I press "Update Password"
    Then I should be on the new password page

  Scenario: Expired recovery token
    And I fill in "email" with email of the first user
    And I press "Reset Password"
    Then I should be on the login page
    And I should see "Email sent with password reset instructions."
    And The User should receive an email
    When I open the email
    And I simulate waiting for 3 hours
    When I click the first link in the email
    Then I should be on the new password page
    Then I fill in "user_password" with "password"
    Then I fill in "user_password_confirmation" with "password"
    And I press "Update Password"
    Then I should be on the login page
    And I should see "Password reset token has expired"
