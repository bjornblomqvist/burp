Feature: i can edit text

  Scenario: i edit some text
    Given I am on a cms page
    When I change a section and reload the page
    Then I should see my changes