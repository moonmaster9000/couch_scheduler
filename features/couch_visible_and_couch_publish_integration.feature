Feature: CouchVisible and CouchPublish Integration
  As a programmer
  I want to integrate CouchScheduler and CouchPublish with CouchVisible
  So that I can query my database for shown, published documents within a schedule

  Scenario: Query for shown, published documents within a schedule
    Given a Slide model that includes CouchVisible, CouchPublish and CouchScheduler
    When I create several shown, published slides scheduled now and in the future
    And I create several hidden, published slides scheduled now and in the future
    When I call "Slide.by_schedule_and_published_and_shown"
    Then I should receive the shown, published documents scheduled now
    When I call "Slide.by_schedule_and_published_and_hidden"
    Then I should receive the hidden, published documents scheduled now
    When I wait till the future
    And I call "Slide.by_schedule_and_published_and_shown"
    Then I should receive the shown, published documents scheduled in the future
    When I call "Slide.by_schedule_and_published_and_hidden"
    Then I should receive the hidden, published documents scheduled in the future
 
  @focus
  Scenario: Count of shown and hidden documents within a schedule
    Given a Slide model that includes CouchVisible, CouchPublish and CouchScheduler
    When I create 2 shown, published slides scheduled now
    And I create 3 shown, published slides schedule in the future
    And I create 4 hidden, published slides scheduled now
    And I create 7 hidden, published slides schedule in the future
    When I call "Slide.count_schedule_and_published_and_shown"
    Then I should receive 2
    When I call "Slide.count_schedule_and_published_and_hidden"
    Then I should receive 4
    When I wait till the future
    And I call "Slide.count_schedule_and_published_and_shown"
    Then I should receive 3
    When I call "Slide.count_schedule_and_published_and_hidden"
    Then I should receive 7
