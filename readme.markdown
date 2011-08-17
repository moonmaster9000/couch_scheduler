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
    @article.start = Time.now
    @article.end   = 6.days.from_now
    @article.save


## Validation

`CouchSchedule` will use `ActiveModel` validation to ensure that your `end` is after your `start`:
  
    @article.start = Time.now
    @article.end   = 2.days.ago
    @article.save #==> false
    @artile.errors #==> [:end, " must be greater than start"]


## Uses?

Now what can you do with these start and end dates? One use: publishing. 

Let's imagine that you only to display this article on your website between the start and end dates. You can use the `within_schedule?` method to determine if an article is available for viewing given the current time:

    @article.within_schedule? #==> true

    # wait 6 days....

    @article.within_schedule? #==> false

### Query (.by_schedule)

You can also query the databases for all of the articles currently within their schedule via `by_schedule`:

    Article.by_schedule

`by_schedule` simply queries a map with a default key of `Time.now.start_of_day`. You can pass any options to it that you would normally pass to a map function in `CouchRest::Model::Base`:

    Article.by_schedule.key(10.days.from_now)
      #==> all the articles active 10 days from now

    Article.by_schedule.startkey(Time.now).endkey(10.days.from_now)
      #==> all the articles active between now and 10 days from now

`CouchVisible` also provides you with a convenience method for getting the count of the `by_schedule` map/reduce:
    
    Article.count_schedule
      #==> the number of documents that are currently within their schedule

Like `by_schedule`, `count_schedule` supports all the usual map/reduce options:

    Article.count_schedule.key(10.days.from_now)
      #==> the count of all articles that are within their start/end dates 10 days from now


## CouchPublish Integration

If you include `CouchScheduler` into a model that already includes `CouchPublish`, then you can pass `:publish => true` and `:unpublish => true`:
    
    # with a class definition like this:
    class Article < CouchRest::Model::Base
      include CouchPublish
      include CouchScheduler

      property :title
    end

    # you can query for all published and currently scheduled documents like this:
    Article.by_schedule.published
      #==> returns all documents that are published and currently within their schedule
    
    # you can also query for the unpublished and currently scheduled documents like this:
    Article.by_schedule.unpublished

You can also pass use the "published" and "unpublished" query proxy methods on the `count_schedule` method.


## CouchVisible Integration

If you include `CouchScheduler` into a model that includes `CouchVisible`, you'll get the following map/reduce functions for free:

    Article.by_schedule.shown
      #==> all articles that are currently within their start and end dates and are shown

    Article.by_schedule.hidden
      #==> all articles that are currently within their start and end dates and are hidden

    Article.count_schedule.shown
    Article.count_schedule.hidden


## CouchPublish/CouchVisible integration

If you include `CouchScheduler` into a model that includes both `CouchVisible` and `CouchPublish`, you can pass `:published => true`, `:unpublished => true`, `:shown => true`, `:hidden => true` to your schedule query methods:

    Article.by_schedule.published.shown
    Article.by_schedule.unpublished.hidden
    Article.count_schedule.published.shown
    Article.count_schedule.unpublished.hidden
 

## LICENSE

This software is PUBLIC DOMAIN. By contributing to it, you agree to let your contribution enter the PUBLIC DOMAIN.
