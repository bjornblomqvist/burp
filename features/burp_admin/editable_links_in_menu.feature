Feature: editable links in menu
  As a user
  I want there to be links in the menu
  So that i can have the menu items point anywhere
  
  Scenario: i add a link to a menu
    Given I am on the edit menu page
    When I add a new link
    Then I should see this new link
  
  Scenario: i edit a link
    Given I am editing a menu that has a link
    When I change the name of the link
    Then the links name should have changed to the new name
  
  