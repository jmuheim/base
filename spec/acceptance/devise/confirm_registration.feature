Feature: Confirm registration
  In order to activate my account
  As a user
  I want to be able to confirm my registration

  Background:
    Given I exist as an unconfirmed user

  Scenario: User opens confirmation link in email
    Given I open the email
    And I follow "Confirm my account" in the email
    Then I should see a successful confirmed message
