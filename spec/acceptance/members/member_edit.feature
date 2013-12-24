Feature: Edit Member
  As a registered member of the website
  I want to edit my member profile
  so I can change my membername

    Scenario: I sign in and edit my account
      Given I am logged in
      When I edit my account details
      Then I should see an account edited message
