
module CapybaraSweet
  class DriverWindow
    attr_reader :browser, :shell
  
    def initialize
      display = Swt::Widgets::Display.get_current
      @shell = Swt::Widgets::Shell.new
      @shell.set_minimum_size(800, 600)
      
      layout = Swt::Layout::FillLayout.new
      @shell.setLayout(layout)
      
      @browser = Swt::Browser.new(@shell, Swt::SWT::NONE)
      RubyFunc.new(@browser, "capybaraSweet")

      @shell.pack
      @shell.open
    end
  end
end