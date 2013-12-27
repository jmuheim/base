Feature: Confirm registration
  In order to activate my account
  As a member
  I want to be able to confirm my registration

    Background:
      Given I exist as an unconfirmed member

    Scenario: Member opens confirmation link in email
      Given I open the email
      And I follow "Confirm my account" in the email
      Then I should see a successful confirmed message