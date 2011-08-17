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

### Query (.map_within_schedule)

You can also query the databases for all of the articles currently within their schedule via `map_within_schedule`:

    Article.map_within_schedule!

`map_within_schedule` simply queries a map with a default key of `Time.now.start_of_day`. You can pass any options to it that you would normally pass to a map function in `CouchRest::Model::Base`:

    Article.map_within_schedule.key(10.days.from_now.to_date).get!
      #==> all the articles active 10 days from now

    Article.map_within_schedule.startkey(Time.now.to_date).endkey(10.days.from_now.to_date).get!
      #==> all the articles active between today and 10 days from now

If you're coming from a regular `CouchRest::Model::Base` background, you've likely not seen this lazy, chainable API before. `CouchScheduler` utilizes `CouchView` to create this functionality. Checkout the `couch_view` gem at http://github.com/moonmaster9000/couch_view

`CouchScheduler` also provides you with a convenience method for getting the count of the `map_within_schedule` map/reduce:
    
    Article.count_within_schedule!
      #==> the number of documents that are currently within their schedule

Like `map_within_schedule`, `count_within_schedule` supports all the usual map/reduce options:

    Article.count_within_schedule.key(10.days.from_now).get!
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
    Article.map_within_schedule.published.get!
      #==> returns all documents that are published and currently within their schedule
    
    # you can also query for the unpublished and currently scheduled documents like this:
    Article.map_within_schedule.unpublished.get!

You can also pass use the "published" and "unpublished" query proxy methods on the `count_within_schedule` method.


## CouchVisible Integration

If you include `CouchScheduler` into a model that includes `CouchVisible`, you'll get the following map/reduce functions for free:

    Article.map_within_schedule.shown.get!
      #==> all articles that are currently within their start and end dates and are shown

    Article.map_within_schedule.hidden.get!
      #==> all articles that are currently within their start and end dates and are hidden

    Article.count_within_schedule.shown.get!
    Article.count_within_schedule.hidden.get!


## CouchPublish/CouchVisible integration

If you include `CouchScheduler` into a model that includes both `CouchVisible` and `CouchPublish`, you can pass `:published => true`, `:unpublished => true`, `:shown => true`, `:hidden => true` to your schedule query methods:

    Article.map_within_schedule.published.shown.get!
    Article.map_within_schedule.unpublished.hidden.get!
    Article.count_within_schedule.published.shown.get!
    Article.count_within_schedule.unpublished.hidden.get!
 

## LICENSE

This software is PUBLIC DOMAIN. By contributing to it, you agree to let your contribution enter the PUBLIC DOMAIN.
