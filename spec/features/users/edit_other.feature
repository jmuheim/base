Feature: Edit Other Users
  As an admin of the website
  I want to edit other user profiles
  so I can change their details

  Background:
    Given a user "Donald" exists

  Scenario: Editing another user's account as admin
    And   I am logged in as admin
    When  I try to request the edit page for the user "Donald"
    Then  access should be granted

  # This scenario isn't really needed, we ensure authorization through heavy ability specs!
  Scenario: Editing another user's account as normal user
    And   I am logged in as user
    When  I try to request the edit page for the user "Donald"
    Then  access should be denied
