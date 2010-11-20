
module Cucumber
  module Ast
    class StepInvocation #:nodoc:#
      class << self
        attr_accessor :wait_time
      end

      def invoke_with_swt(step_mother, options)
        wait_on_location_change
        
        CapybaraSweet.sync_exec { invoke_without_swt(step_mother, options) }
        sleep ENV["SLOW_CUKES"].to_f if ENV["SLOW_CUKES"]
        sleep(Cucumber::Ast::StepInvocation.wait_time || 0)
        Cucumber::Ast::StepInvocation.wait_time = nil
        
        wait_on_response
        wait_on_location_change
        wait_on_active_ajax
      end
      
      def wait_on_active_ajax
        num_active_ajax = 1
        while num_active_ajax > 0
          CapybaraSweet.sync_exec do
            num_active_ajax = CapybaraSweet.driver_window.browser.evaluate("return $.active")
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
          # CapybaraSweet.sync_exec do
          #   p CapybaraSweet.driver_window.browser.evaluate("return $(\"html\")[0].innerHTML")
          # end
        end
        CapybaraSweet.driver_window.location_listener.reset
        CapybaraSweet.driver_window.progress_listener.reset
      end
      
      alias_method :invoke_without_swt, :invoke
      alias_method :invoke, :invoke_with_swt
    end
  end  
end