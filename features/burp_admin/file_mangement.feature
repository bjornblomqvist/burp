Feature: file managment
  As a user
  I want to be able to upload and manage files
  So that i can share them with the world

  Scenario: I upload a file
    Given there are no files
    When I go and upload a file
    Then there should be one file that i can link to
    
  Scenario: I remove a file
    Given there is a file
    When I go and remove it
    Then there should be no files
    
  Scenario: I remove a image
    Given there is a large image with scaled down versions
    When I go and remove it
    Then no versions of the file should be left
    
  Scenario: I view a file
    Given there is a text file
    When I go to the text file
    Then I should see its content
    