Feature: Show Members
  As a visitor to the website
  I want to see registered members listed on the homepage
  so I can know if the site has members

    Scenario: Viewing members
      Given I exist as a member
      When I look at the list of members
      Then I should see my name
