Feature: CouchVisible and CouchPublish Integration
  As a programmer
  I want to integrate CouchScheduler and CouchPublish with CouchVisible
  So that I can query my database for shown, published documents within a schedule

  Scenario: Query for shown, published documents within a schedule
    Given an Article model that includes CouchVisible, CouchPublish and CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchPublish
          include CouchVisible
          include CouchScheduler
        end
      """

    When I create several shown, published articles scheduled now and in the future:
      """
        @current_published_shown_articles = []
        @future_published_shown_articles = []

        3.times { @current_published_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish!; a.show!; a.save }}
        3.times { @future_published_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish!; a.show!; a.save}}
      """

    And I create several shown, unpublished articles scheduled now and in the future:
      """
        @current_unpublished_shown_articles = []
        @future_unpublished_shown_articles = []

        3.times { @current_unpublished_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.save }}
        3.times { @future_unpublished_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save}}
      """

    And I create several hidden, published articles scheduled now and in the future:
      """
        @current_published_hidden_articles = []
        @future_published_hidden_articles = []

        3.times { @current_published_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish!}}
        3.times { @future_published_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish!}}
      """


    And I create several hidden, unpublished articles scheduled now and in the future:
      """
        @current_unpublished_hidden_articles = []
        @future_unpublished_hidden_articles = []

        3.times { @current_unpublished_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
        3.times { @future_unpublished_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    Then "Article.map_within_schedule.published.shown.get!" should return the shown, published documents scheduled now:
      """
        Article.map_within_schedule.published.shown.get!.collect(&:id).sort.should == @current_published_shown_articles.collect(&:id).sort
      """

    And "Article.map_within_schedule.published.hidden.get!" should return the published, hidden documents scheduled now:
      """
        Article.map_within_schedule.published.hidden.get!.collect(&:id).sort.should == @current_published_hidden_articles.collect(&:id).sort
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.by_schedule.published.shown.get!" should return the published, visible documents scheduled in the future:
      """
        Article.map_within_schedule.published.shown.get!.collect(&:id).sort.should == @future_published_shown_articles.collect(&:id).sort
      """
    
    And "Article.map_within_schedule.published.hidden.get!" should return the published, hidden documents scheduled now:
      """
        Article.map_within_schedule.published.hidden.get!.collect(&:id).sort.should == @future_published_hidden_articles.collect(&:id).sort
      """


  Scenario: Count of shown and hidden documents within a schedule
    Given an Article model that includes CouchVisible, CouchPublish and CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchPublish
          include CouchVisible
          include CouchScheduler
        end
      """

    When I create 2 shown, published articles scheduled now and 10 in the future:
      """
        @current_published_shown_articles = []
        @future_published_shown_articles = []

        2.times { @current_published_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish!; a.show!; a.save }}
        10.times { @future_published_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish!; a.show!; a.save}}
      """

    And I create 3 shown, unpublished articles scheduled now and 8 in the future:
      """
        @current_unpublished_shown_articles = []
        @future_unpublished_shown_articles = []

        3.times { @current_unpublished_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.save }}
        8.times { @future_unpublished_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save}}
      """

    And I create 5 hidden, published articles scheduled now and 14 in the future:
      """
        @current_published_hidden_articles = []
        @future_published_hidden_articles = []

        5.times { @current_published_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish!}}
        14.times { @future_published_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish!}}
      """


    And I create 11 hidden, unpublished articles scheduled now and in the future:
      """
        @current_unpublished_hidden_articles = []
        @future_unpublished_hidden_articles = []

        11.times { @current_unpublished_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
        11.times { @future_unpublished_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    Then "Article.count_within_schedule.published.shown.get!" should return 2:
      """
        Article.count_within_schedule.published.shown.get!.should == 2
      """

    And "Article.count_within_schedule.published.hidden.get!" should return 5:
      """
        Article.count_within_schedule.published.hidden.get!.should == 5
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.count_within_schedule.published.shown.get!" should return 10:
      """
        Article.count_within_schedule.published.shown.get!.should == 10
      """

    And "Article.count_within_schedule.published.hidden.get!" should return 14:
      """
        Article.count_within_schedule.published.hidden.get!.should == 14
      """
