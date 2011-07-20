Given /^an Post model that includes CouchVisible and CouchScheduler$/ do
  unless defined? Post
    class Post < CouchRest::Model::Base 
      include CouchVisible
      include CouchScheduler
    end
  end
end

When /^I create several shown posts scheduled now and in the future$/ do
  @shown_now = []
  @shown_future = []

  5.times { @shown_now    << Post.create(:start => Time.now,       :end => 1.day.from_now ).tap {|a| a.show!; a.save }}
  5.times { @shown_future << Post.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save }}
end

When /^I create several hidden posts scheduled now and in the future$/ do
  @hidden_now = []
  @hidden_future = []

  5.times { @hidden_now    << Post.create(:start => Time.now,       :end => 1.day.from_now ).tap {|a| a.hide!; a.save }}
  5.times { @hidden_future << Post.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide!; a.save }}
end

Then /^I should receive the shown documents scheduled now$/ do
  @result.collect(&:id).sort.should == @shown_now.collect(&:id).sort
end

Then /^I should receive the hidden documents scheduled now$/ do
  @result.collect(&:id).sort.should == @hidden_now.collect(&:id).sort
end

Then /^I should receive the shown documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @shown_future.collect(&:id).sort
end

Then /^I should receive the hidden documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @hidden_future.collect(&:id).sort
end

When /^I create (\d+) shown posts scheduled now$/ do |num|
  @shown_now = []
  num.to_i.times { @shown_now    << Post.create(:start => Time.now,       :end => 1.day.from_now ).tap {|a| a.show!; a.save }}
end

When /^I create (\d+) shown posts schedule in the future$/ do |num|
  @shown_future = []
  num.to_i.times { @shown_future << Post.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.save }}
end

When /^I create (\d+) hidden posts scheduled now$/ do |num|
  @hidden_now = []
  num.to_i.times { @hidden_now << Post.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.hide!; a.save }}
end

When /^I create (\d+) hidden posts schedule in the future$/ do |num|
  @hidden_future = []
  num.to_i.times { @hidden_future << Post.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide!; a.save }}
end
