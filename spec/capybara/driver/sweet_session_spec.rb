
require 'spec_helper'

describe Capybara::Session do
  context 'with sweet driver' do
    before do
      @session = Capybara::Session.new(:sweet, TestApp)
    end

    after do
    end

    describe '#driver' do
      it "should be a terminus driver" do
        @session.driver.should be_an_instance_of(Capybara::Driver::Sweet)
      end
    end

    describe '#mode' do
      it "should remember the mode" do
        @session.mode.should == :sweet
      end
    end

    it_should_behave_like "session"
    it_should_behave_like "session without headers support"
    it_should_behave_like "session with javascript support"
    it_should_behave_like "session without status code support"
  end
end
