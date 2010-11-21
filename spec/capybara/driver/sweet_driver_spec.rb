
require 'spec_helper'

describe Capybara::Driver::Sweet do
  before do
    @driver = Capybara::Driver::Sweet.new(TestApp)
  end

  after do
  end

  it_should_behave_like "driver"
  it_should_behave_like "driver with javascript support"
  it_should_behave_like "driver without status code support"
  #it_should_behave_like "driver with support for window switching"
  it_should_behave_like "driver with cookies support"
  #it_should_behave_like "driver with infinite redirect detection"
end
