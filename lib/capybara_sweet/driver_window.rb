
module CapybaraSweet
  class DriverWindow
    attr_reader :browser, :shell, :location_listener, :progress_listener
  
    def initialize
      display = Swt::Widgets::Display.get_current
      @shell = Swt::Widgets::Shell.new
      @shell.set_minimum_size(800, 600)
      
      layout = Swt::Layout::FillLayout.new
      @shell.setLayout(layout)
      
      @browser = Swt::Browser.new(@shell, Swt::SWT::NONE)
      RubyFunc.new(@browser, "capybaraSweet")
      
      @location_listener = LocationListener.new
      @progress_listener = ProgressListener.new
      @browser.add_location_listener(@location_listener)
      @browser.add_progress_listener(@progress_listener)
      
      @shell.pack
      @shell.open
    end
    
    class LocationListener
      def changed(*_);  @changed = true;  end
      def changing(*_); @changed = true;  end

      def reset;        @changed = false; end
      def changed?;     @changed;         end
    end
    
    class ProgressListener
      def changed(*_);                       end
      def completed(*_); @completed = true;  end
      
      def reset;         @completed = false; end
      def completed?;    @completed;         end
    end

  end
end