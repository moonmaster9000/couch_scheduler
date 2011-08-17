Given /^an.*:$/ do |code|
  eval code
end

When /^I (?:set|wait) .*:$/ do |code|
  eval code
end

Then /^.*should.*:$/ do |code|
  eval code
end

Given /^there are.*:$/ do |code|
  eval code
end

Given /^a model that includes CouchScheduler:$/ do |code|
  eval code
end

Given /^the date is .*:$/ do |code|
  eval code
end
