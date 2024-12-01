require "bundler/setup"
require "debug"

input = File.readlines(__dir__ + "/input.txt")

a, b = input.map { |l| l.split(/\s+/).map(&:strip).map(&:to_i) }
  .transpose
  .map(&:sort)

frequencies = b.tally

puts a.inject(0) { |sum, entry| sum + entry * (frequencies[entry] || 0) }
