module Garnet
  class Runtime
    attr_reader :stack

    def initialize program
      @stack = []
      @program = program
      @execution_environment = Module.new do
        def self.arr(*args)
          return args
        end
      end
    end

    def execute_all
      @program.each do |inst|
        execute_instruction inst
      end
    end

    def execute_instruction instruction
      case instruction.type
      when :drop
        @stack.pop
      when :push_const
        # Push constant onto stack
        @stack << instruction.value
      when :call_imp
        # Pull target from instruction
        target = instruction.value

        # Infer argument count
        arg_count = @execution_environment.instance_eval do
          method(target).arity
        end
        raise 'unable to determine argument count' if arg_count == -1

        # Make call
        perform_call target, arg_count
      when :call_hash_imp
        # Pull target from instruction
        target = instruction.value

        # Pop object
        object = @stack.pop

        # Infer argument count
        arg_count = @execution_environment.instance_eval do
          object.method(target).arity
        end
        raise 'unable to determine argument count' if arg_count == -1

        # Make call
        perform_dot_call object, target, arg_count
      when :call_exp
        # Pull target and argument count from instruction
        target, arg_count = instruction.value

        # Make call
        perform_call target, arg_count
      when :call_hash_exp
        # Pull target and argument count from instruction
        target, arg_count = instruction.value

        # Pop object
        object = @stack.pop

        # Make call
        perform_dot_call object, target, arg_count
      end
    end

    def perform_call target, arg_count
      # Gather arguments
      args = []
      arg_count.times { args << @stack.pop }

      # Run call inside execution environment
      @stack << @execution_environment.instance_eval do
        send target, *args
      end
    end

    def perform_dot_call object, target, arg_count
      # Gather arguments
      args = []
      arg_count.times { args << @stack.pop }
      args.reverse!

      # Run call inside execution environment
      @stack << @execution_environment.instance_eval do
        object.send target, *args
      end
    end
  end
end