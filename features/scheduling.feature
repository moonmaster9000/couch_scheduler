Feature: Scheduling
  As a programmer
  I want the ability to schedule my documents
  So that I can control when they are accessible

  Scenario: Setting valid start and end dates
    Given an instance of a model that includes CouchScheduler
    When I set "start" to now
    And I set "end" to a day from now
    Then I should be able to save my document
  
  Scenario: Setting invalid start and end dates
    Given an instance of a model that includes CouchScheduler
    When I set "start" to now
    And I set "end" to yesterday
    Then I should not be able to save my document
    And I should get an error message that the end "must be greater than start"

  @focus
  Scenario: Determining if a document is within it's schedule 
    Given an instance of a model that includes CouchScheduler
    When I set "start" to now
    And I set "end" to a day from now
    Then "within_schedule?" should return true
    When I wait two days
    Then "within_schedule?" should return false
  
  @focus
  Scenario: Determining if a document is within it's schedule for a document that has only a start date
    Given an instance of a model that includes CouchScheduler
    When I set "start" to a day from now
    Then "within_schedule?" should return false
    When I wait two days
    Then "within_schedule?" should return true

  @focus
  Scenario: Determining if a document is within it's schedule for a document that has only an end date
    Given an instance of a model that includes CouchScheduler
    When I set "end" to a day from now
    Then "within_schedule?" should return true
    When I wait two days
    Then "within_schedule?" should return false
