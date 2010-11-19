
class Capybara::Driver::Sweet < Capybara::Driver::Base
  def initialize(app)
    @app = app
    
  end
  
  def visit
    
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
  
  def browser
    CapybaraSweet.driver_window.browser
  end
end

Capybara.register_driver :sweet do |app|
  Capybara::Driver::Sweet.new(app)
end
  
