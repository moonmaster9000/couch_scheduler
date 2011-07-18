Given /^an instance of a model that includes CouchScheduler$/ do
  class Model < CouchRest::Model::Base
    include CouchScheduler
  end
  @instance = Model.new
end

When /^I set "([^"]*)" to now$/ do |property|
  @instance.send "#{property}=", Time.now
end

When /^I set "([^"]*)" to a day from now$/ do |property|
  @instance.send "#{property}=", 1.day.from_now
end

Then /^I should be able to save my document$/ do
  @instance.save
  @instance.errors.empty?.should be(true)
end

When /^I set "([^"]*)" to yesterday$/ do |property|
  @instance.send "#{property}=", 1.day.ago
end

Then /^I should not be able to save my document$/ do
  @instance.save
  @instance.errors.empty?.should be(false)
end

Then /^I should get an error message that the end "([^"]*)"$/ do |end_message|
  @instance.errors[:end].should == [end_message]
end

Then /^"([^"]*)" should return true$/ do |method|
  @instance.send(method).should be(true)
end

When /^I set "([^"]*)" to a week from now$/ do |property|
  @instance.send "#{property}=", 1.week.from_now
end

Then /^"([^"]*)" should return false$/ do |method|
  @instance.send(method).should be(false)
end

When /^I wait two days$/ do
  tomorrow = 2.days.from_now.beginning_of_day
  Timecop.freeze tomorrow
end
