Feature: Edit Own User
  As a registered user of the website
  I want to edit my user profile
  so I can change my details

  Scenario: I sign in and edit my account
    Given I am logged in as user
    When  I edit my account details
    Then  I should see an account edited message

  Scenario: I sign in and edit another user's account
    Given a user "Donald" exists
    And   I am logged in as user
    When  I try to edit the account details of "Donald"
    Then  I should see an access denied message