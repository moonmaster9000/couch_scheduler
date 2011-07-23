Given /^a Slide model that includes CouchVisible, CouchPublish and CouchScheduler$/ do
  unless defined? Slide
    class Slide < CouchRest::Model::Base
      include CouchVisible
      include CouchPublish
      include CouchScheduler
    end
  end
end

When /^I create several shown, published slides scheduled now and in the future$/ do
  @published_shown_now = []
  @published_shown_future = []

  5.times { @published_shown_now << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.publish! } }
  5.times { @published_shown_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.publish! } }
end

When /^I create several shown, unpublished slides scheduled now and in the future$/ do
  @unpublished_shown_now = []
  @unpublished_shown_future = []

  5.times { @unpublished_shown_now << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!} }
  5.times { @unpublished_shown_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!} }
end


When /^I create several hidden, published slides scheduled now and in the future$/ do
  @published_hidden_now = []
  @published_hidden_future = []

  5.times { @published_hidden_now    << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.hide!; a.publish! } }
  5.times { @published_hidden_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide!; a.publish! } }
end

When /^I create several hidden, unpublished slides scheduled now and in the future$/ do
  @unpublished_hidden_now = []
  @unpublished_hidden_future = []

  5.times { @unpublished_hidden_now    << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.hide! } }
  5.times { @unpublished_hidden_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide! } }
end

Then /^I should receive the shown, published documents scheduled now$/ do
  @result.collect(&:id).sort.should == @published_shown_now.collect(&:id).sort
end

Then /^I should receive the hidden, published documents scheduled now$/ do
  @result.collect(&:id).sort.should == @published_hidden_now.collect(&:id).sort
end

Then /^I should receive the shown, published documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @published_shown_future.collect(&:id).sort
end

Then /^I should receive the hidden, published documents scheduled in the future$/ do
  @result.collect(&:id).sort.should == @published_hidden_future.collect(&:id).sort
end

When /^I create (\d+) shown, published slides scheduled now$/ do |num|
  @published_shown_now = []
  num.to_i.times { @published_shown_now << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!; a.publish!}}
end

When /^I create (\d+) shown, published slides schedule in the future$/ do |num|
  @published_shown_future = []
  num.to_i.times { @published_shown_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!; a.publish!}}
end

When /^I create (\d+) hidden, published slides scheduled now$/ do |num|
  @published_hidden_now = []
  num.to_i.times { @published_hidden_now << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.hide!; a.publish!}}
end

When /^I create (\d+) hidden, published slides schedule in the future$/ do |num|
  @published_hidden_future = []
  num.to_i.times { @published_hidden_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide!; a.publish!}}
end

When /^I create (\d+) shown, unpublished slides scheduled now$/ do |num|
  @unpublished_shown_future = []
  num.to_i.times { @unpublished_shown_future << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.show!}}
end

When /^I create (\d+) shown, unpublished slides schedule in the future$/ do |num|
  @unpublished_shown_future = []
  num.to_i.times { @unpublished_shown_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.show!}}
end

When /^I create (\d+) hidden, unpublished slides scheduled now$/ do |num|
  @unpublished_hidden_now = []
  num.to_i.times { @unpublished_hidden_now << Slide.create(:start => Time.now, :end => 1.day.from_now).tap {|a| a.hide!}}
end

When /^I create (\d+) hidden, unpublished slides schedule in the future$/ do |num|
  @unpublished_hidden_future = []
  num.to_i.times { @unpublished_hidden_future << Slide.create(:start => 1.day.from_now, :end => 2.days.from_now).tap {|a| a.hide!}}
end
