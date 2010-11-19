
When /^I visit "(.*)"$/ do |path|
  visit(path)
end

Then /^I should see "(.*)"$/ do |expected|
  body.include?(expected).should be_true
end