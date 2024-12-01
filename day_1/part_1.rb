require "bundler/setup"
require "debug"

input = File.readlines(__dir__ + "/input.txt")

a, b = input.map { |l| l.split(/\s+/).map(&:strip).map(&:to_i) }
  .transpose
  .map(&:sort)

puts a.zip(b)
    .map { |a, b| (b - a).abs }
    .sum
