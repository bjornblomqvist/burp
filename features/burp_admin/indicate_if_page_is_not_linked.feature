Feature: indicate if page is not in any menu
  In order to know if i should add a link to a page
  As a administrator
  I want to see if a page is not in any menu
  
  Scenario: no page is linked in a menu
    Given I have two pages
    When I go to the page listing
    Then I should that none of the pages are linked
  
  Scenario: one page is linked in a menu
    Given I have two pages
    And one of them is linked in a menu
    When I go to the page listing
    Then I should see that only one of them is not linked