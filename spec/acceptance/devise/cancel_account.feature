Feature: Cancel account
  In order to remove any footprints
  As a user
  I want to be able to cancel my account

  Background:
    Given I am logged in as user

  Scenario: User cancels account
    When I cancel my account
    Then I should see a good bye message
