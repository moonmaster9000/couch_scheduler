Feature: CouchPublish Integration
  As a programmer
  I want to integrate CouchScheduler with CouchPublish
  So that I can query my database for published documents within a schedule

  Scenario: Query for published documents within a schedule
    Given an Article model that includes CouchPublish and CouchVisible
    When I create several published articles scheduled now and in the future
    And I create several unpublished articles scheduled now and in the future
    When I call "Article.by_schedule_and_published"
    Then I should receive the published documents scheduled now
    When I call "Article.by_schedule_and_unpublished"
    Then I should receive the unpublished documents scheduled now
    When I wait till the future
    And I call "Article.by_schedule_and_published"
    Then I should receive the published documents scheduled in the future
    When I call "Article.by_schedule_and_unpublished"
    Then I should receive the unpublished documents scheduled in the future
 
  @focus
  Scenario: Count of published and unpublished documents within a schedule
    Given an Article model that includes CouchPublish and CouchVisible
    When I create 2 published articles scheduled now
    And I create 3 published articles schedule in the future
    And I create 4 unpublished articles scheduled now
    And I create 7 unpublished articles schedule in the future
    When I call "Article.count_schedule_and_published"
    Then I should receive 2
    When I call "Article.count_schedule_and_unpublished"
    Then I should receive 4
    When I wait till the future
    And I call "Article.count_schedule_and_published"
    Then I should receive 3
    When I call "Article.count_schedule_and_unpublished"
    Then I should receive 7   
