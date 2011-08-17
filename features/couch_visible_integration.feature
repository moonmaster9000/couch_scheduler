Feature: CouchVisible Integration
  As a programmer
  I want to integrate CouchScheduler with CouchVisible
  So that I can query my database for shown documents within a schedule

  Scenario: Query for shown documents within a schedule
   Given an Article model that includes CouchVisible and CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchVisible
          include CouchScheduler
        end
      """
    
    When I create several shown articles scheduled now and in the future:
      """
        @current_shown_articles = []
        @future_shown_articles = []

        3.times { @current_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.save }}
        3.times { @future_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save }}
      """

    And I create several hidden articles scheduled now and in the future:
      """
        @current_hidden_articles = []
        @future_hidden_articles = []
        
        3.times { @current_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
        3.times { @future_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    When I call "Article.map_within_schedule.shown.get!":
      """
        @result = Article.map_within_schedule.shown.get!
      """

    Then I should receive the shown documents scheduled now:
      """
        @result.all? {|a| @current_shown_articles.collect(&:id).include? a.id }.should be(true)
        @result.length.should == @current_shown_articles.length
      """

    When I call "Article.map_within_schedule.hidden.get!":
      """
        @result = Article.map_within_schedule.hidden.get!
      """

    Then I should receive the hidden documents scheduled now:
      """
        @result.collect(&:id).sort.should == @current_hidden_articles.collect(&:id).sort
        @result.length.should == @current_hidden_articles.length
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.map_within_schedule.shown.get!" should return the shown documents I had scheduled in the future:
      """
        Article.map_within_schedule.shown.get!.collect(&:id).sort.should == @future_shown_articles.collect(&:id).sort
      """

    And "Article.map_within_schedule.hidden.get!" should return the hidden documents I had scheduled in the future:
      """
        Article.map_within_schedule.hidden.get!.collect(&:id).sort.should == @future_hidden_articles.collect(&:id).sort
      """


  @focus 
  Scenario: Count of shown and hidden documents within a schedule
 
    Given an Article model that includes CouchScheduler and CouchVisible:
      """
        class Article < CouchRest::Model::Base
          include CouchVisible
          include CouchScheduler
        end
      """
    
    When I create 2 shown articles scheduled now:
      """
        @current_shown_articles = []

        2.times { @current_shown_articles << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.save }}
      """

    When I create 3 shown articles scheduled in the future:
      """
        @future_shown_articles = []

        3.times { @future_shown_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save }}
      """

    And I create 4 hidden articles scheduled now:
      """
        @current_hidden_articles = []
        
        4.times { @current_hidden_articles << Article.create(:start => Time.now, :end => 1.day.from_now)}
      """

    And I create 10 hidden articles scheduled in the future:
      """
        @future_hidden_articles = []
        
        10.times { @future_hidden_articles << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
      """

    When I call "Article.count_within_schedule.shown.get!":
      """
        @result = Article.count_within_schedule.shown.get!
      """

    Then I should receive the count of the shown documents scheduled now:
      """
        @result.should == 2
      """

    When I call "Article.count_within_schedule.hidden.get!":
      """
        @result = Article.count_within_schedule.hidden.get!
      """

    Then I should receive the count of the hidden documents scheduled now:
      """
        @result.should == 4
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "Article.count_within_schedule.shown.get!" should return the count of the shown documents I had scheduled in the future:
      """
        Article.count_within_schedule.shown.get!.should == 3
      """

    And "Article.map_within_schedule.hidden.get!" should return the count of the hidden documents I had scheduled in the future:
      """
        Article.count_within_schedule.hidden.get!.should == 10
      """
