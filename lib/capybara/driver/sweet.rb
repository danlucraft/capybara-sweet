
class Capybara::Driver::Sweet < Capybara::Driver::Base
  def initialize(app)
    @app = app
    
  end
  
  def visit(path)
    url = Capybara.app_host + path
    listener = ProgressListener.new
    browser.add_progress_listener(listener)
    browser.set_url(url)
    $wait_for_completion = listener
  end
  
  def body
    browser.get_text
  end
  
  def current_path
    
  end
  
  def current_url
    
  end
  
  def evaluate_script
    
  end
  
  def execute_script
    
  end
  
  def find(xpath)
    p body
    p xpath
    r = Nokogiri::HTML(body).xpath(xpath)
    p r
    r
  end
  
  def reset!
    
  end
  
  def source
    
  end
  
  private
  
  class ProgressListener
    def changed(*_); end
    
    def completed(*_)
      p :completed
      @completed = true
    end
    
    def completed?
      @completed
    end
  end
  
  def browser
    CapybaraSweet.driver_window.browser
  end
end

Capybara.register_driver :sweet do |app|
  Capybara::Driver::Sweet.new(app)
end
  
