require_relative 'instruction'
require_relative 'runtime'
require_relative 'parser'

include Garnet

program = Parser.new('8 2 #+ puts$1 #').parse

runtime = Runtime.new program
runtime.execute_all
