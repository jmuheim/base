Feature: Valid HTML5
  blabla

    Scenario: Member is not signed up
      Given I do not exist as a member
      When I sign in with valid username and password
      Then I see an invalid login message
      And I should be signed out
      And the page should be valid HTML5
