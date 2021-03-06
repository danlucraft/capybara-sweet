
module Cucumber
  module Ast
    class StepInvocation #:nodoc:#
      class << self
        attr_accessor :wait_time
      end

      def invoke_with_swt(step_mother, options)
        # CapybaraSweet.sync_exec { 
          invoke_without_swt(step_mother, options)
        # }
        sleep ENV["SLOW_CUKES"].to_f if ENV["SLOW_CUKES"]
        sleep(Cucumber::Ast::StepInvocation.wait_time || 0)
        Cucumber::Ast::StepInvocation.wait_time = nil
      end
      
      alias_method :invoke_without_swt, :invoke
      alias_method :invoke, :invoke_with_swt
    end
  end  
end