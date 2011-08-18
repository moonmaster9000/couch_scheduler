Feature: Scheduling
  As a programmer
  I want the ability to schedule my documents
  So that I can control when they are accessible


  Scenario: Setting valid start and end dates
    
    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    When I set "start" to now:
      """
        @article.start = Time.now.to_date
      """

    And I set "end" to a day from now:
      """
        @article.end = 1.day.from_now.to_date
      """

    Then I should be able to save my document:
      """
        @article.save
        @article.errors.should be_empty
        Article.all.count.should == 1
      """
  
  
  Scenario: Setting invalid start and end dates

    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    When I set "start" to now:
      """
        @article.start = Time.now.to_date
      """

    And I set "end" to yesterday:
      """
        @article.end = 1.day.ago.to_date
      """

    Then I should not be able to save my document:
      """
        @article.save
        @article.errors.should_not be_empty
        Article.all.count.should == 0
      """  
  
  
  Scenario: Determining if a document is within it's schedule 

    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    When I set "start" to now:
      """
        @article.start = Time.now.to_date
      """

    And I set "end" to tomorrow:
      """
        @article.end = 1.day.from_now.to_date
      """

    Then "within_schedule?" should return true on my instance:
      """
        @article.within_schedule?.should be(true)
      """

    When I wait two days:
      """
        Timecop.freeze 2.days.from_now
      """

    Then "within_schedule?" should return false on my instance:
      """
        @article.within_schedule?
      """

  
  Scenario: Determining if a document is within it's schedule for a document that has only a start date
    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    When I set "start" to now:
      """
        @article.start = Time.now.to_date
      """
    
    Then "within_schedule?" should return true on my instance:
      """
        @article.within_schedule?.should be(true)
      """

    When I wait two days:
      """
        Timecop.freeze 2.days.from_now
      """

    Then "within_schedule?" should return true on my instance:
      """
        @article.within_schedule?.should be(true)
      """


  @focus
  Scenario: Determining if a document is within it's schedule for a document that has only an end date

    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    When I set "end" to tomorrow:
      """
        @article.end = 1.day.from_now.to_date
      """
    
    Then "within_schedule?" should return true on my instance:
      """
        @article.within_schedule?.should be(true)
      """

    When I wait two days:
      """
        Timecop.freeze 2.days.from_now
      """

    Then "within_schedule?" should return false on my instance:
      """
        @article.within_schedule?.should be(false)
      """
  

  @focus
  Scenario: Getting all documents that are within schedule on a given date 

    Given an instance of a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end

        @article = Article.new
      """

    And there are several documents currently scheduled:
      """
        @current_articles = [].tap {|a| 10.times { a << Article.create(:start => Time.now, :end => 1.day.from_now) }}
        @current_articles.length.should == 10
      """

    And there are several documents scheduled in the future:
      """
        @future_articles = [].tap {|a| 10.times { a << Article.create(:start => 2.days.from_now, :end => 3.days.from_now) }}
        @future_articles.length.should == 10
        Article.all.count.should == 20
      """

    Then "map_within_schedule!" should return the documents currently within schedule:
      """
        Article.map_within_schedule!.all? {|a| @current_articles.collect(&:id).include? a.id }
      """

    And "map_within_schedule!" should not return the documents scheduled in the future:
      """
        Article.map_within_schedule!.all? {|a| !@future_articles.collect(&:id).include? a.id }
      """
    
    Then "map_within_schedule.key(2.days.from_now.to_date).get!" should return the documents scheduled in the future:
      """
        Article.map_within_schedule.key(2.days.from_now.to_date).get!.all? {|a| @future_articles.collect(&:id).include? a.id }
      """

    And "map_within_schedule.key(2.days.from_now.to_date).get!" should not return the documents currently scheduled:
      """
        Article.map_within_schedule.key(2.days.from_now.to_date).get!.all? {|a| !@current_articles.collect(&:id).include? a.id }
      """


  @focus
  Scenario: Counting documents
    
    Given a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end
      """
    
    And there are 3 documents scheduled between now and tomorrow:
      """
        3.times { Article.create :start => Time.now, :end => 1.day.from_now}
      """

    And there are 10 documents scheduled between tomorrow and two days from now:
      """
        10.times { Article.create :start => 1.day.from_now, :end => 2.days.from_now }
      """

    Then "count_within_schedule!" should return 3:
      """
        Article.count_within_schedule!.should == 3
      """

    And "count_within_schedule.key(1.day.from_now.to_date).get!" should return 10:
      """
        Article.count_within_schedule.key(1.day.from_now.to_date).get!.should == 10
      """

    When I wait a day:
      """
        Timecop.freeze 1.day.from_now
      """

    Then "count_within_schedule!" should return 10:
      """
        Article.count_within_schedule!.should == 10
      """

    When I wait another day:  
      """
        Timecop.freeze 1.day.from_now
      """

    Then "count_within_schedule!" should return 0:
      """
        Article.count_within_schedule!.should == 0
      """

  @focus
  Scenario: Generating the correct date key index for scheduled documents
    
    Given a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end
      """
    
    And the date is January 1st, 2011:
      """
        Timecop.freeze Time.parse("2011/01/01")
      """

    And there are 3 documents scheduled between now and one month and a day from now:
      """
        3.times { Article.create :start => Time.now, :end => (1.month.from_now + 1.day)}
      """

    And there are 10 documents scheduled between one month and a day from now and two months from now:
      """
        10.times { Article.create :start => (1.month.from_now + 1.day), :end =>  2.months.from_now }
      """
    
    Then "count_within_schedule!" should return 3:
      """
        Article.count_within_schedule!.should == 3
      """

    And "count_within_schedule.key('2011-01-01').get!" should return 3:
      """
        Article.count_within_schedule.key('2011-01-01').get!.should == 3
      """

    And "count_within_schedule.key('2011-02-02).get!" should return 10:
      """
        Article.count_within_schedule.key('2011-02-02').get!.should == 10
      """

    When I wait a month and a day:
      """
        Timecop.freeze(1.month.from_now + 1.day)
      """

    Then "count_within_schedule!" should return 10:
      """
        Article.count_within_schedule!.should == 10
      """

  @focus
  Scenario: Default start within the "schedule" index to the current date
    
    Given a model that includes CouchScheduler:
      """
        class Article < CouchRest::Model::Base
          include CouchScheduler
        end
      """
    
    And there are 3 documents scheduled to end one month and a day from now:
      """
        3.times { Article.create :end => (1.month.from_now + 1.day)}
      """

    And there are 10 documents scheduled to start one month and a day from now:
      """
        10.times { Article.create :start => (1.month.from_now + 1.day)}
      """
    
    Then "count_within_schedule!" should return 3:
      """
        Article.count_within_schedule!.should == 3
      """

    And "count_within_schedule.key(Time.now.to_date).get!" should return 3:
      """
        Article.count_within_schedule.key(Time.now.to_date).get!.should == 3
      """

    And "count_within_schedule.key((1.month.from_now + 1.day).to_date).get!" should return 10:
      """
        Article.count_within_schedule.key((1.month.from_now + 1.day).to_date).get!.should == 10
      """

    When I wait a month and a day:
      """
        Timecop.freeze(1.month.from_now + 1.day)
      """

    Then "count_within_schedule!" should return 10:
      """
        Article.count_within_schedule!.should == 10
      """
