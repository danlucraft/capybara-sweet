
class Capybara::Driver::Sweet < Capybara::Driver::Base
  def initialize(app)
    if app
      @app = app
      @rack_server = Capybara::Server.new(@app)
      @rack_server.boot if Capybara.run_server
    end
  end
  
  def visit(path)
    run do
      browser.set_url(url(path))
    end
  end
  
  def url(path)
    if @rack_server
      @rack_server.url(path)
    else
      Capybara.app_host + path
    end
  end
  
  def body
    run do
      browser.evaluate("return $(\"html\")[0].innerHTML")
    end
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
    run do
      doc = Nokogiri::HTML(body) 
      r = doc.xpath(xpath)
      r.map {|element| Node.new(element)}
    end
  end
  
  def reset!
    
  end
  
  def source
    
  end
  
  def run
    CapybaraSweet.sync
    result = CapybaraSweet.sync_exec { yield }
    CapybaraSweet.sync
    result
  end
  
  class Node < Capybara::Driver::Node
    def initialize(element)
      @element = element
    end
    
    def find(xpath)
      run do
        @element.xpath(xpath).map {|el| Node.new(el)}
      end
    end
    
    def click(*args)
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          element = document.evaluate("#{path}", document, null, XPathResult.ANY_TYPE, null).iterateNext();
          Syn.trigger('click', {}, element);
          capybaraSweet("finished_click")
        }
        catch(e) {
          alert(e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_click"]
      end
    end
    
    def set(value)
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          field = document.evaluate("#{path}", document, null, XPathResult.ANY_TYPE, null).iterateNext();
          if (field.type === 'file') return callback('not_allowed');
            
            Syn.trigger('focus', {}, field);
            Syn.trigger('click', {}, field);
            var value = #{value.inspect};
          switch (typeof value) {
            case 'string':  field.value = value;    break;
            case 'boolean': field.checked = value;  break;
            }
            capybaraSweet("finished_set")
          }
        catch(e) {
          alert(e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_set"]
      end
    end
    
    def select_option
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          node = document.evaluate("#{path}", document, null, XPathResult.ANY_TYPE, null).iterateNext();
          node.selected = true;
          Syn.trigger('change', {}, node.parentNode);
          capybaraSweet("finished_select");
        }
        catch(e) {
          alert(e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_select"]
      end
    end
    
    def tag_name
      @element.name
    end
    
    def path
      @element.path.gsub("/table", "/table/tbody").gsub("/tbody/tbody", "/tbody")
    end
    
    def browser
      CapybaraSweet.driver_window.browser
    end
        
    def run
      CapybaraSweet.sync
      result = CapybaraSweet.sync_exec { yield }
      CapybaraSweet.sync
      result
    end
  end
  
  private
  
  def browser
    CapybaraSweet.driver_window.browser
  end
end

Capybara.register_driver :sweet do |app|
  Capybara::Driver::Sweet.new(app)
end
  
