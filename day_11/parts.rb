require_relative "../setup"

module Day11
  # class Stone
  #
  # end

  class Part
    def self.from_input_file
      new "5688 62084 2 3248809 179 79 0 172169"
      # new "125 17"
    end

    def initialize(input)
      @input = input.split(" ").map(&:to_i)
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
      25.times do
        @input = @input.map { |value| tick(value) }.flatten
      end

      @input.length
    end
  end

  class Part2 < Part
    def solve
      map = TopoMap.new(@input)
      map.find_trailheads.sum do |trailhead|
        map.find_ways_up(trailhead).length
      end
    end
  end
end

puts
puts Day11::Part1.from_input_file.solve
