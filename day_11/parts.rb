require_relative "../setup"
require "benchmark"

module Day11
  class Part
    def self.from_input_file
      new "5688 62084 2 3248809 179 79 0 172169"
      # new "125 17"
    end

    def initialize(input)
      @input = input.split(" ").map(&:to_i).tally
    end
  end

  class Part1 < Part
    def tick(value)
      case
      when value == 0
        1
      when value.to_s.length % 2 == 0
        value = value.to_s
        substr_length = value.length / 2

        [value[0..substr_length - 1], value[substr_length..]].map(&:to_i)
      else
        value * 2024
      end
    end

    def solve
      75.times do |i|
        @input = @input
          .map { |value, count| Array(tick(value)).map { |value| [value, count] } }
          .flatten(1)
          .each_with_object({}) { |(value, count), acc| acc[value] = (acc[value] || 0) + count }
      end

      @input.values.sum
    end
  end
end

puts
puts Day11::Part1.from_input_file.solve
