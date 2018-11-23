require_relative 'instruction'

module Garnet
  class Parser
    def initialize code 
      @code = code
    end

    def parse
      tokens = @code.split
      tokens.map do |token|
        # Is this a drop literal?
        if token == '#'
          Instruction.new :drop, nil
        # Is this an integer constant?
        elsif !!(Integer(token) rescue false)
          Instruction.new :push_const, Integer(token)
        # Is this a float constant?
        elsif !!(Float(token) rescue false)
          Instruction.new :push_const, Float(token)
        # This is a function call
        else
          # Determine the kind of function call
          is_exp = token.include? '$'
          is_hash = token.start_with? '#'

          if is_exp && is_hash 
            type = :call_hash_exp
            split_token = token.split '$'
            target = split_token[0].delete '#'
            arg_count = split_token[1].to_i

            Instruction.new type, [target, arg_count]
          elsif !is_exp && is_hash
            type = :call_hash_imp
            target = token.delete '#'

            Instruction.new type, target
          elsif is_exp && !is_hash
            type = :call_exp
            split_token = token.split '$'
            target = split_token[0]
            arg_count = split_token[1].to_i

            Instruction.new type, [target, arg_count]
          elsif !is_exp && !is_hash
            type = :call_imp

            Instruction.new type, token
          end
        end
      end
    end
  end
end