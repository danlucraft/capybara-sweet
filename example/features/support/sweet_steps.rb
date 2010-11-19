
When /^I visit "(.*)"$/ do |path|
  visit(path)
end

Then /^I should see "(.*)"$/ do |expected|
  body.include?(expected).should be_true
end

When /I wait/ do 
  sleep 5
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  select(value, :from => field)
end