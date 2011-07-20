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

  Scenario: Determining if a document is within it's schedule 
    Given an instance of a model that includes CouchScheduler
    When I set "start" to now
    And I set "end" to a day from now
    Then "within_schedule?" should return true on my instance
    When I wait two days
    Then "within_schedule?" should return false on my instance
  
  Scenario: Determining if a document is within it's schedule for a document that has only a start date
    Given an instance of a model that includes CouchScheduler
    When I set "start" to a day from now
    Then "within_schedule?" should return false on my instance
    When I wait two days
    Then "within_schedule?" should return true on my instance

  Scenario: Determining if a document is within it's schedule for a document that has only an end date
    Given an instance of a model that includes CouchScheduler
    When I set "end" to a day from now
    Then "within_schedule?" should return true on my instance
    When I wait two days
    Then "within_schedule?" should return false on my instance
  
  Scenario: Getting all documents that are within schedule on a given date 
    Given there are several documents currently scheduled
    And there are several documents scheduled in the future
    Then "by_schedule" should return the documents currently within schedule
    And "by_schedule" should not return the documents scheduled in the future

  @focus
  Scenario: Counting documents
    Given there are 3 documents scheduled between now and tomorrow
    And ther are 10 documents scheduled between tomorrow and two days from now
    Then "count_by_schedule" should return 3
    And "count_by_schedule :key => 1.day.from_now" should return 10
    When I wait a day
    Then "count_by_schedule" should return 10
    When I wait another day
    Then "count_by_schedule" should return 0
