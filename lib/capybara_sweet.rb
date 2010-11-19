
require 'java'
require 'capybara-sweet/swt/swt_wrapper'

require 'rubygems'
require 'cucumber'
require 'capybara-sweet/cucumber_patches'

module CapybaraSweet
  class << self
    attr_reader :driver_window, :display
  end
  
  def self.setup
    @driver_window = DriverWindow.new
    start_gui
  end
  
  def self.start_gui
    @display = Swt::Widgets::Display.get_current
    
    while !CapybaraSweet.driver_window.shell.isDisposed
      @display.sleep unless @display.read_and_dispatch
    end

    @display.dispose
  end
  
  class DriverWindow
    attr_reader :browser, :shell
  
    def initialize
      display = Swt::Widgets::Display.get_current
      @shell = Swt::Widgets::Shell.new
      @shell.set_minimum_size(800, 600)
      
      layout = Swt::Layout::FillLayout.new
      @shell.setLayout(layout)
      
      @browser = Swt::Browser.new(@shell, Swt::SWT::NONE)
      
      @shell.pack
      @shell.open
    end
  end
end

Swt::Widgets::Display.set_app_name "Capybara Sweet"
