
require 'java'
require 'capybara_sweet/swt/swt_wrapper'

require 'rubygems'
require "cucumber/cli/main"
require "cucumber"
require "cucumber/rb_support/rb_language"
require 'capybara'
require 'capybara_sweet/javascript_functions'
require 'capybara_sweet/cucumber_patches'
require 'capybara_sweet/driver_window'
require 'capybara_sweet/sync'

module CapybaraSweet
  class << self
    attr_reader :driver_window, :display
  end
  
  def self.setup
    @driver_window = DriverWindow.new
  end
  
  def self.start_gui
    @display = Swt::Widgets::Display.get_current
    
    while !CapybaraSweet.driver_window.shell.isDisposed
      @display.sleep unless @display.read_and_dispatch
    end

    @display.dispose
  end
  
  START_DELAY = 1
  
  def self.sync_exec(&block)
    runnable = Swt::RRunnable.new(&block)
    display.syncExec(runnable)
    runnable.result
  end
  
  def self.browser_responses
    @browser_responses ||= []
  end
  
  def self.sync
    sync = CapybaraSweet::Sync.new
    sync.wait_on_response
    sync.wait_on_location_change
    sync.wait_on_active_ajax
  end
  
  def self.run_features(args)
    Thread.new do
      begin
        sleep START_DELAY
        main = Cucumber::Cli::Main.new(args)
        main.execute!
        sync_exec { CapybaraSweet.driver_window.shell.dispose }
      rescue Object => e
        puts e.message
        puts e.backtrace
      end
    end
  end
  
end

Swt::Widgets::Display.set_app_name "Capybara Sweet"
