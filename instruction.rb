module Garnet
  class Instruction
    attr_reader :type, :value

    TYPES = [:push_const, :call_imp, :call_exp, :call_hash_imp, :call_hash_exp, :drop]

    def initialize type, value
      raise 'invalid type' unless TYPES.include? type

      @type = type
      @value = value
    end
  end
end