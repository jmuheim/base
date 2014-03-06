Feature: Destroy Own User
  As a registered user of the website
  I want to be unable to destroy my account
  so I don't accidently lock myself out

  Scenario: I sign in and destroy my account
    Given I am logged in as user
    When  I try to request the deletion of user "Testy McUserton"
    Then  access should be denied
