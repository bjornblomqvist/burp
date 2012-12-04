Feature: file managment
  As a user
  I want to be able to upload and manage files
  So that i can share them with the world

  Scenario: i upload a file
    Given there are no files
    When I go and upload a file
    Then there should be one file that i can link to
  @wip  
  Scenario: i remove a file
    Given there is a file
    When I go and remove it
    Then there should be no files
  