require_relative "../setup"
require_relative "./map"

module Day6
  class Part
    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read
  end

  class Part1 < Part
    def initialize(input)
      @map = Map.new(input)
    end

    def solve
      @map.guard.move

      @map.guard.guarded_coordinates.length
    end
  end

  class Part2 < Part
    def initialize(input)
      @input = input
    end

    def solve
      possible_new_obstacle_coordinates.each_with_index.count do |coordinate, i|
        puts "testing #{coordinate} (#{i})"

        map = Map.new(@input)
        map.obstacle_coordinates << coordinate
        map.guard.move
        map.guard.loop?
      end
    end

    private

    def possible_new_obstacle_coordinates
      Map.new(@input)
         .tap { |map| map.guard.move }
         .guard
         .guarded_coordinates
         .tap { |coordinates| puts "Must test #{coordinates.length} coordinates" }
    end
  end
end

# puts Day6::Part1.from_input_file.solve
puts Day6::Part2.from_input_file.solve
