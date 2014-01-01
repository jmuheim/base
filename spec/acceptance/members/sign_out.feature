Feature: Sign out
  To protect my account from unauthorized access
  A signed in member
  Should be able to sign out

    Scenario: Member signs out
      Given I am logged in
      When I sign out
      Then I should see a signed out message
      When I return to the site
      Then I should be signed out
