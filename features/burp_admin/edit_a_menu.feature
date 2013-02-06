Feature: edit a menu

  Scenario: i go and edit the first menu
    Given I am on the first page of the admin
    When I go and add a link to the first menu
    Then I should see the new link in the menu