
module Cucumber
  module Ast
    class StepInvocation #:nodoc:#
      class << self
        attr_accessor :wait_time
      end

      def invoke_with_swt(step_mother, options)
        CapybaraSweet.sync_exec { invoke_without_swt(step_mother, options) }
        sleep ENV["SLOW_CUKES"].to_f if ENV["SLOW_CUKES"]
        sleep(Cucumber::Ast::StepInvocation.wait_time || 0)
        Cucumber::Ast::StepInvocation.wait_time = nil
        if listener = $wait_for_completion
          true until listener.completed?
          CapybaraSweet.sync_exec do 
            CapybaraSweet.driver_window.browser.remove_progress_listener(listener)
          end
          $wait_for_completion = nil
        end
      end

      alias_method :invoke_without_swt, :invoke
      alias_method :invoke, :invoke_with_swt
    end
  end  
end