
When /^I visit "(.*)"$/ do |path|
  visit(path)
end

Then /^I should see "(.*)"$/ do |expected|
  r = body
  r.include?(expected).should be_true
end

When /I wait/ do 
  sleep 5
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  select(value, :from => field)
end

When /^I enter "([^"]*)" into "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /^I press "([^"]*)"$/ do |button|
  click_link_or_button(button)
end
