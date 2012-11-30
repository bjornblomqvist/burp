Feature: change the name of a group
  As a user
  I want to change the name of a group
  So that it better reflects its content
  
  Scenario: i change a groups name
    Given I am editing a menu that has a group
    When I change the name of the group
    Then the groups name should have changed to the new name