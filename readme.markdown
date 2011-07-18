# Couch Scheduler

Schedule your `CouchRest::Model::Base` documents with start and end dates. What those start and end dates signify is up to you.

## Installation

It's a gem called `couch_scheduler`. Install it in whatever way is appropriate to you.

## Basics

The gem includes a module, `CouchScheduler`, that you can mix into your documents.

For example, let's imagine that the we have an Article model:

    class Article < CouchRest::Model::Base
      include CouchScheduler

      property :title
    end

You can now provide start and end dates for your articles:
    
    @article = Article.create :title => "Couch Scheduler is simple and cool."
    @article.schedule_start = Time.now
    @article.schedule_end   = 6.days.from_now
    @article.save

## Validation

`CouchSchedule` will use `ActiveModel` validation to ensure that your `schedule_end` is after your `schedule_start`:
  
    @article.schedule_start = Time.now
    @article.schedule_end   = 2.days.ago
    @article.save #==> false
    @artile.errors #==> [:schedule_end, " must be greater than schedule_start"]

## Uses?

Now what can you do with these start and end dates? One use: publishing. 

Let's imagine that you only to display this article on your website between the start and end dates. You can use the `within_schedule?` method to determine if an article is available for viewing given the current time:

    @article.within_schedule? #==> true

    # wait 6 days....

    @article.within_schedule? #==> false

You can also query the databases for all of the articles currently within their schedule via `by_within_schedule`:

    Article.by_within_schedule

`by_within_schedule` simply queries a map with a default key of `Time.now.start_of_day`. You can pass any options to it that you would normally pass to a map function in `CouchRest::Model::Base`:

    Article.by_within_schedule :key => 10.days.from_now
      #==> all the articles active 10 days from now

    Article.by_within_schedule :startkey => Time.now, :endkey => 10.days.from_now
      #==> all the articles active between now and 10 days from now

`CouchVisible` also provides you with a convenience method for getting the count of the `by_within_schedule` map/reduce:
    
    Article.count_within_schedule
      #==> the number of documents that are currently within their schedule

Like `by_within_schedule`, `count_within_schedule` supports all the usual map/reduce options:

    Article.count_within_schedule :key => 10.days.from_now
      #==> the count of all articles that are within their start/end dates 10 days from now

## CouchPublish Integration

If you include `CouchScheduler` into a model that already includes `CouchPublish`, then you get a new map function for free, `by_within_schedule_and_published`:
    
    # with a class definition like this:
    class Article < CouchRest::Model::Base
      include CouchPublish
      include CouchScheduler
      property :title
    end

    # you can query for all published and currently scheduled documents like this:
    Article.by_within_schedule_and_published
      #==> returns all documents that are published and currently within their schedule
    
    # you can also query for the unpublished and currently scheduled documents like this:
    Article.by_within_schedule_and_unpublished

## CouchVisible Integration

If you include `CouchScheduler` into a model that includes `CouchVisible`, you'll get the following map/reduce functions for free:

    Article.by_within_schedule_and_shown
      #==> all articles that are currently within their start and end dates and are shown

    Article.by_within_schedule_and_hidden
      #==> all articles that are currently within their start and end dates and are hidden

    Article.count_within_schedule_and_shown
    Article.count_within_schedule_and_hidden

## CouchPublish/CouchVisible integration

If you include `CouchScheduler` into a model that includes both `CouchVisible` and `CouchPublish`, you'll get the following map/reduce functions for free:

    Article.by_within_schedule_and_published_and_shown
    Article.by_within_schedule_and_published_and_hidden
    Article.by_within_schedule_and_unpublished_and_shown
    Article.by_within_schedule_and_unpublished_and_hidden

And of course, all the corresponding `count` methods are available:

    Article.count_within_schedule_and_published_and_shown
    Article.count_within_schedule_and_published_and_hidden
    Article.count_within_schedule_and_unpublished_and_shown
    Article.count_within_schedule_and_unpublished_and_hidden

## LICENSE

This software is PUBLIC DOMAIN. By contributing to it, you agree to let your contribution enter the PUBLIC DOMAIN.
