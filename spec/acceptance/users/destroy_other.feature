Feature: Destroy Other Users
  As an admin of the website
  I want to destroy other user profiles
  so I can remove unwanted users

  Background:
    Given a user "Donald" exists

  Scenario: Destroying another user's account as admin
    And   I am logged in as admin
    When  I try to request the deletion of user "Donald"
    Then  access should be granted

  # This scenario isn't really needed, we ensure authorization through heavy ability specs!
  Scenario: Destroying another user's account as normal user
    And   I am logged in as user
    When  I try to request the deletion of user "Donald"
    Then  access should be denied
