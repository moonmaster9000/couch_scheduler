Feature: CouchVisible Integration
  As a programmer
  I want to integrate CouchScheduler with CouchVisible
  So that I can query my database for shown documents within a schedule

  Scenario: Query for shown documents within a schedule
    Given an Post model that includes CouchVisible and CouchScheduler
    When I create several shown posts scheduled now and in the future
    And I create several hidden posts scheduled now and in the future
    When I call "Post.by_schedule :shown => true"
    Then I should receive the shown documents scheduled now
    When I call "Post.by_schedule :hidden => true"
    Then I should receive the hidden documents scheduled now
    When I wait till the future
    And I call "Post.by_schedule :shown => true"
    Then I should receive the shown documents scheduled in the future
    When I call "Post.by_schedule :hidden => true"
    Then I should receive the hidden documents scheduled in the future
  
  @focus 
  Scenario: Count of shown and hidden documents within a schedule
    Given an Post model that includes CouchVisible and CouchScheduler
    When I create 2 shown posts scheduled now
    And I create 3 shown posts schedule in the future
    And I create 4 hidden posts scheduled now
    And I create 7 hidden posts schedule in the future
    When I call "Post.count_schedule :shown => true"
    Then I should receive 2
    When I call "Post.count_schedule :hidden => true"
    Then I should receive 4
    When I wait till the future
    And I call "Post.count_schedule :shown => true"
    Then I should receive 3
    When I call "Post.count_schedule :hidden => true"
    Then I should receive 7   
