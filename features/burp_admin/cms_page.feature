Feature: cms page
  As a user
  I want to have editable cms page with just static content
  So that i can easily add text,pictures,videos and files
  
  Scenario: i change the title of a page
    Given there is a page
    When I go and change the title of that page
    Then that page should show the new title when viewed
    
  Scenario: i change the page path
    Given there is a page
    When I go and change the path of that page
    Then that page should be found on the new path

  Scenario: i add a page
    Given there are no pages
    When I go and add a page
    Then I there should be a page
  @wip  
  Scenario: i remove a page
    Given there is a page
    When I remove the page
    Then there should be no pages