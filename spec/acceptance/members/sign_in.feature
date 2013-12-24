Feature: Sign in
  In order to get access to protected sections of the site
  A member
  Should be able to sign in

    Scenario: Member is not signed up
      Given I do not exist as a member
      When I sign in with valid credentials
      Then I see an invalid login message
      And I should be signed out

    Scenario: Member signs in successfully
      Given I exist as a member
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in

    Scenario: Member enters wrong email
      Given I exist as a member
      And I am not logged in
      When I sign in with a wrong email
      Then I see an invalid login message
      And I should be signed out
      
    Scenario: Member enters wrong password
      Given I exist as a member
      And I am not logged in
      When I sign in with a wrong password
      Then I see an invalid login message
      And I should be signed out

      