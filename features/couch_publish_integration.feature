Feature: CouchPublish Integration
  As a programmer
  I want to integrate CouchScheduler with CouchPublish
  So that I can query my database for published documents within a schedule

  @focus
  Scenario: Query for published documents within a schedule
    Given an Article model that includes CouchPublish and CouchVisible:
      """
        class Article < CouchRest::Model::Base
          include CouchPublish
          include CouchScheduler
        end
      """
    
    When I create several published articles scheduled now and in the future:
      """
        @current_published_articles = []
        @future_published_articles = []

        3.times { @current_published_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish! }}
        3.times { @future_published_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish! }}
      """

    And I create several unpublished articles scheduled now and in the future:
      """
        @current_unpublished_articles = []
        @future_unpublished_articles = []
        
        3.times { @current_unpublished_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
        3.times { @future_unpublished_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    When I call "Article.map_within_schedule.published.get!":
      """
        @result = Article.map_within_schedule.published.get!
      """

    Then I should receive the published documents scheduled now:
      """
        @result.all? {|a| @current_published_articles.collect(&:id).include? a.id }.should be(true)
        @result.length.should == @current_published_articles.length
      """

    When I call "Article.map_within_schedule.unpublished.get!":
      """
        @result = Article.map_within_schedule.unpublished.get!
      """

    Then I should receive the unpublished documents scheduled now:
      """
        @result.collect(&:id).sort.should == @current_unpublished_articles.collect(&:id).sort
        @result.length.should == @current_unpublished_articles.length
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.map_within_schedule.published.get!" should return the published documents I had scheduled in the future:
      """
        Article.map_within_schedule.published.get!.collect(&:id).sort.should == @future_published_articles.collect(&:id).sort
      """

    And "Article.map_within_schedule.unpublished.get!" should return the unpublished documents I had scheduled in the future:
      """
        Article.map_within_schedule.unpublished.get!.collect(&:id).sort.should == @future_unpublished_articles.collect(&:id).sort
      """


  @focus
  Scenario: Count of published and unpublished documents within a schedule

    Given an Article model that includes CouchPublish and CouchVisible:
      """
        class Article < CouchRest::Model::Base
          include CouchPublish
          include CouchScheduler
        end
      """
    
    When I create 2 published articles scheduled now:
      """
        @current_published_articles = []

        2.times { @current_published_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish! }}
      """

    When I create 3 published articles scheduled in the future:
      """
        @future_published_articles = []

        3.times { @future_published_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish! }}
      """

    And I create 4 unpublished articles scheduled now:
      """
        @current_unpublished_articles = []
        
        4.times { @current_unpublished_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
      """

    And I create 10 unpublished articles scheduled in the future:
      """
        @future_unpublished_articles = []
        
        10.times { @future_unpublished_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    When I call "Article.count_within_schedule.published.get!":
      """
        @result = Article.count_within_schedule.published.get!
      """

    Then I should receive the count of the published documents scheduled now:
      """
        @result.should == 2
      """

    When I call "Article.count_within_schedule.unpublished.get!":
      """
        @result = Article.count_within_schedule.unpublished.get!
      """

    Then I should receive the count of the unpublished documents scheduled now:
      """
        @result.should == 4
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.count_within_schedule.published.get!" should return the count of the published documents I had scheduled in the future:
      """
        Article.count_within_schedule.published.get!.should == 3
      """

    And "Article.map_within_schedule.unpublished.get!" should return the count of the unpublished documents I had scheduled in the future:
      """
        Article.count_within_schedule.unpublished.get!.should == 10
      """
