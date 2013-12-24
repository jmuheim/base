Feature: Confirm registration
  In order to activate my account
  As a member
  I want to be able to confirm my registration

    Background:
      Given I exist as an unconfirmed member

    Scenario: Member opens confirmation link in email
      When I open the confirmation link
      Then I should see a successful sign up message