Feature: file upload
  As a user
  I want to be able to upload files
  So that i can link to them
  @wip
  Scenario: i upload a file
    Given there are no files
    When I go and upload a file
    Then there should be one file that i can link to
  