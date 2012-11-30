Feature: edit text

  Scenario: i change a snippet
    Given I am on a cms page
    When I change a section and reload the page
    Then I should see my changes