
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
  
  def current_url
    run do
      browser.get_url
    end
  end
  
  def reset!
    CapybaraSweet.sync_exec do
      Swt::Browser.clear_sessions
    end
  end
  
  def body
    run do
      browser.evaluate("return document.documentElement.innerHTML;")
    end
  end
  
  def source
    run do
      browser.get_text
    end
  end
  
  def find(xpath)
    run do
      doc = Nokogiri::HTML(body) 
      r = doc.xpath(xpath)
      r.map {|element| Node.new(self, element)}
    end
  end
  
  alias :all :find
  
  def evaluate_script(script)
    run do
      browser.evaluate("return (#{script})")
    end
  end
  
  def run
    CapybaraSweet.sync
    result = CapybaraSweet.sync_exec { yield }
    CapybaraSweet.sync
    result
  end
  
  class Node < Capybara::Driver::Node
    def find(xpath)
      native.xpath(xpath).map {|el| Node.new(driver, el)}
    end
    
    def text
      native.text
    end
    
    def [](name)
      native.attr(name)
    end
    
    def get_element
      "document.evaluate(\"#{path}\", document, null, XPathResult.ANY_TYPE, null).iterateNext();"
    end
    
    def visible?
      run do
        browser.evaluate(script=<<-JAVASCRIPT)
          var node = #{get_element}

          while (node.tagName.toLowerCase() !== 'body') {
            if (node.style.display === 'none' || node.type === 'hidden')
              return false;
            node = node.parentNode;
          }
          return true;
        JAVASCRIPT
      end
    end
    
    def drag_to(node)
      run do
        browser.evaluate(script=<<-JAVASCRIPT)
          var from = #{get_element}
          var to = #{node.get_element}
          Syn.drag({to: to}, from, function() { sweetCallback("finished_drag"); });
        JAVASCRIPT
        $wait_for_response = ["finished_drag"]
      end
    end
    
    def value
      run do
        browser.evaluate(script=<<-JAVASCRIPT)
          element = #{get_element}
          return element.value;
        JAVASCRIPT
      end
    end
    
    def click(*args)
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          element = #{get_element}
          Syn.trigger('click', {}, element);
          sweetCallback("finished_click")
        }
        catch(e) {
          sweetLog("click: " + e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_click"]
      end
    end
    
    def set(value)
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          field = #{get_element}
          if (field.type === 'file') {
            sweetLog("can't set file elements");
            sweetCallback("finished_set")
          }
          else { 
            Syn.trigger('focus', {}, field);
            Syn.trigger('click', {}, field);
            var value = #{value.inspect};
            switch (typeof value) {
              case 'string':  field.value = value;    break;
                case 'boolean': field.checked = value;  break;
                }
            sweetCallback("finished_set")
          }
        }
        catch(e) {
          sweetLog("set: " + e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_set"]
      end
    end
    
    def select_option
      run do
        browser.execute(script=<<-JAVASCRIPT)
        try {
          node = #{get_element}
          node.selected = true;
          Syn.trigger('change', {}, node.parentNode);
          sweetCallback("finished_select");
        }
        catch(e) {
          sweetLog("select_option: " + e);
        }
        JAVASCRIPT
        $wait_for_response = ["finished_select"]
      end
    end
    
    def tag_name
      native.name
    end
    
    def path
      native.path.gsub("/table", "/table/tbody").gsub("/tbody/tbody", "/tbody")
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
  
