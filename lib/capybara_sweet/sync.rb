
module CapybaraSweet
  class Sync
    def wait_on_active_ajax
      num_active_ajax = 1
      while num_active_ajax > 0
        CapybaraSweet.sync_exec do
          begin
            num_active_ajax = CapybaraSweet.driver_window.browser.evaluate("return $.active")
          rescue => e
            if e.message =~ /Can't find variable: \$/
              num_active_ajax = 0
            end
          end
        end
      end
    end

    def wait_on_response
      if required_response = $wait_for_response
        true until CapybaraSweet.browser_responses.include?(required_response)
        $wait_for_response = nil
      end
      CapybaraSweet.browser_responses.clear
    end
    
    def wait_on_location_change
      if CapybaraSweet.driver_window.location_listener.changed?
        until CapybaraSweet.driver_window.progress_listener.completed?
          true
        end
      end
      CapybaraSweet.driver_window.location_listener.reset
      CapybaraSweet.driver_window.progress_listener.reset
    end
  end
end