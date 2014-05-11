Feature: meta description
  In order to have a good description in the search results
  As a user
  I want to be to be able to add a meta description for each page

  Scenario: I add a description
    Given there is a page
    When I add a meta description for this page
    Then I should see the description in the header of the page