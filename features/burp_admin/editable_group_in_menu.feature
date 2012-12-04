Feature: editable group in menu
  As a admin
  I want to add a group to a menu
  So that I can organice my links in groups
  
  Scenario: i add a group
    Given I am on the edit menu page
    When I add a new group
    Then I should see this new group
    
  Scenario: i change a groups name
    Given I am editing a menu that has a group
    When I change the name of the group
    Then the groups name should have changed to the new name

  Scenario: i remove a group
    Given I am editing a menu that has a group
    When I remove the group
    Then I should not any longer see the group in the menu
    
  Scenario: i change a groups name but i deside not to save the change
    Given I am editing a menu that has a group
    When I change the name of the group but deside not to keep the changes
    Then the groups name should not have changed
    