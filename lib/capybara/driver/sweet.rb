
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
    doc = Nokogiri::HTML(body) 
    r = doc.xpath(xpath)
    r1 = r.map {|element| Node.new(element)}
    r1
  end
  
  def reset!
    
  end
  
  def source
    
  end
  
  class Node < Capybara::Driver::Node
    def initialize(element)
      @element = element
    end
    
    def find(xpath)
      p @element.path
      @element.xpath(xpath).map {|el| Node.new(el)}
    end
    
    def select_option
      p [:select_option, self]
      browser.execute(script=<<-JAVASCRIPT)
        node = document.evaluate("#{path}", document, null, XPathResult.ANY_TYPE, null).iterateNext();
        node.selected = true;
        Syn.trigger('change', {}, node.parentNode);
        
      JAVASCRIPT
      puts script
      $wait_for_status = listener
    end
    
    def tag_name
      @element.name
    end
    
    def path
      @element.path.gsub("/table", "/table/tbody")
    end
    
    def browser
      CapybaraSweet.driver_window.browser
    end
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

  class RubyFunc < Swt::Browser::BrowserFunction
    def function(args)
      begin
        if result = controller.send(*args.to_a)
          return JSON(result)
        else
          return "{}"
        end
      rescue JSON::GeneratorError => e
        nil
      rescue Object => e
        puts "caught in controller"
        puts e.message
        puts e.backtrace
      end
    end

    attr_accessor :controller
  end

  def browser
    CapybaraSweet.driver_window.browser
  end
end

Capybara.register_driver :sweet do |app|
  Capybara::Driver::Sweet.new(app)
end
  
