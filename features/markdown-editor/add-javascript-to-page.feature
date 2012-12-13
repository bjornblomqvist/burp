Feature: add javascript to page
  As a user
  I want to be able to add inline javascript
  So that i can do all that javascript magic!
  
  Scenario: when adding javascript to section i am told that the javascript will be saved but not previewed.
    Given I am on a cms page
    When I add a alert box to a section
    Then I should see message about javascript
  
  Scenario: i add a alert box and test it
    Given I am on a cms page
    When I add a alert box to the page and reload
    Then I should see the alert box 
    