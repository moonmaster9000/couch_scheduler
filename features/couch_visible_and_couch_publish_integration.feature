Feature: CouchVisible and CouchPublish Integration
  As a programmer
  I want to integrate CouchScheduler and CouchPublish with CouchVisible
  So that I can query my database for shown, published documents within a schedule

  Scenario: Query for shown, published documents within a schedule
    Given a Slide model that includes CouchVisible, CouchPublish and CouchScheduler
    When I create several shown, published slides scheduled now and in the future
    And I create several shown, unpublished slides scheduled now and in the future
    And I create several hidden, published slides scheduled now and in the future
    And I create several hidden, unpublished slides scheduled now and in the future
    When I call "Slide.by_schedule :published => true, :shown => true"
    Then I should receive the shown, published documents scheduled now
    When I call "Slide.by_schedule :published => true, :hidden => true"
    Then I should receive the hidden, published documents scheduled now
    When I wait till the future
    And I call "Slide.by_schedule :published => true, :shown => true"
    Then I should receive the shown, published documents scheduled in the future
    When I call "Slide.by_schedule :published =>true, :hidden => true"
    Then I should receive the hidden, published documents scheduled in the future
 
  @focus
  Scenario: Count of shown and hidden documents within a schedule
    Given a Slide model that includes CouchVisible, CouchPublish and CouchScheduler
    When I create 2 shown, published slides scheduled now
    When I create 6 shown, unpublished slides scheduled now
    And I create 3 shown, published slides schedule in the future
    And I create 9 shown, unpublished slides schedule in the future
    And I create 4 hidden, published slides scheduled now
    And I create 12 hidden, unpublished slides scheduled now
    And I create 7 hidden, published slides schedule in the future
    And I create 21 hidden, unpublished slides schedule in the future
    When I call "Slide.count_schedule :published => true, :shown => true"
    Then I should receive 2
    When I call "Slide.count_schedule :published => true"
    Then I should receive 6
    When I call "Slide.count_schedule"
    Then I should receive 24
    When I call "Slide.count_schedule :published =>true, :hidden => true"
    Then I should receive 4
    When I wait till the future
    And I call "Slide.count_schedule :published => true, :shown => true"
    Then I should receive 3
    When I call "Slide.count_schedule :published =>true, :hidden => true"
    Then I should receive 7
