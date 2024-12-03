require "bundler/setup"
require "debug"

input = Pathname.new(__dir__).join("input.txt").read

pp input.scan(/mul\((\d+),(\d+)\)/).sum { |a, b| a.to_i * b.to_i }
