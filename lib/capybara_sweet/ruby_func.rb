
module CapybaraSweet
  class RubyFunc < Swt::Browser::BrowserFunction
    def function(args)
      CapybaraSweet.browser_responses << args.to_a
      nil
    end
  end
end