Feature: cms page
  As a user
  I want to have editable cms page with just static content
  So that i can easily add text,pictures,videos and files
  
  Scenario: i change the title of a page
    Given there is a page
    When I go and change the title of that page
    Then that page should show the new title when viewed
  @wip
  Scenario: i change the page path
    Given there is a page
    When I go and change the path of that page
    Then that page should be found on the new path