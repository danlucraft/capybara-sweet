
module CapybaraSweet
  class CallbackFunction < Swt::Browser::BrowserFunction
    def function(args)
      CapybaraSweet.browser_responses << args.to_a
      nil
    end
  end

  class LoggingFunction < Swt::Browser::BrowserFunction
    def function(args)
      puts "LOG: #{args.to_a.inspect}"
      nil
    end
  end
end