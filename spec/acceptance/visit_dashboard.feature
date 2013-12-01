@chrome
Feature: Visiting the dashboard
  Background:
    Given I'm a guest

  Scenario: displaying the welcome message
    When I visit the dashboard
    Then the welcome message is displayed