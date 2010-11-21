
$:.push(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'capybara_sweet'
require 'capybara/driver/sweet'
require 'capybara/spec/test_app'
require 'capybara/spec/driver'
require 'capybara/spec/session'

class TestApp
  template :layout do
    <<-HTML
      <html>
        <head>
          <meta http-equiv="Content-type" content="text/html; charset=utf-8">
          <title>Capybara Sweet Driver Test</title>
          <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
        </head>
        <body>
          <%= yield %>
        </body>
      </html>
    HTML
  end
end

alias :running :lambda

RSpec.configure do |c|
  c.before(:each) do
  end
  
  c.after(:each) do
  end
  
  c.after(:suite) do
    Thread.new { sleep 1; CapybaraSweet.sync_exec { CapybaraSweet.driver_window.shell.dispose } }
  end
end
