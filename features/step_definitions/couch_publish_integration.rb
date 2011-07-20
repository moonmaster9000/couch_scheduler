Given /^an Article model that includes CouchPublish and CouchVisible$/ do
  unless defined?(Article)
    class Article < CouchRest::Model::Base
      include CouchPublish
      include CouchScheduler
    end
  end
end

When /^I create several published articles scheduled now and in the future$/ do
  @published_now = []
  @published_future = []

  5.times { @published_now << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish! } }
  5.times { @published_future << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish! } }
end

When /^I create several unpublished articles scheduled now and in the future$/ do
  @unpublished_now = []
  @unpublished_future = []

  5.times { @unpublished_now << Article.create(:start => Time.now, :end => 1.day.from_now) }
  5.times { @unpublished_future << Article.create(:start => 1.day.from_now, :end => 2.days.from_now) }
end

When /^I call "([^"]*)"$/ do |code|
  @result = eval code
end

Then /^I should receive the published documents scheduled now$/ do
  @result.collect(&:id).sort.should == @published_now.collect(&:id).sort
end

Then /^I should receive the unpublished documents scheduled now$/ do
  @result.collect(&:id).sort.should == @unpublished_now.collect(&:id).sort
end

When /^I wait till the future$/ do
  Timecop.freeze 1.day.from_now
end

Then /^I should receive the published documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @published_future.collect(&:id).sort
end

Then /^I should receive the unpublished documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @unpublished_future.collect(&:id).sort
end

When /^I create (\d+) published articles scheduled now$/ do |num|
  @published_now = []
  num.to_i.times { @published_now << Article.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.publish!}}
end

When /^I create (\d+) published articles schedule in the future$/ do |num|
  @published_future = []
  num.to_i.times { @published_future << Article.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.publish!}}
end

When /^I create (\d+) unpublished articles scheduled now$/ do |num|
  @unpublished_now = []
  num.to_i.times { @unpublished_now << Article.create(:start => Time.now, :end => 1.day.from_now)}
end

When /^I create (\d+) unpublished articles schedule in the future$/ do |num|
  @unpublished_future = []
  num.to_i.times { @unpublished_future << Article.create(:start => 1.day.from_now, :end => 2.days.from_now)}
end

Then /^I should receive (\d+)$/ do |count|
  @result.should == count.to_i
end
