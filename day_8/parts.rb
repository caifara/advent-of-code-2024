require_relative "../setup"
require_relative "./map"

module Day8
  class Part
    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    def self.from_test_input_file = new Pathname.new(__dir__).join("test_input.txt").read

    def initialize(input)
      @input = input
    end
  end

  class Part1 < Part
    def solve
      Map.new(@input)
         .tap(&:find_antinode_coordinates_v1)
         .antinode_coordinates
        .length
    end
  end

  class Part2 < Part
    def solve
      map = Map.new(@input)
               .tap(&:find_antinode_coordinates_v2)

      coors_set = map.antinode_coordinates +
                  map.antennas_w_coordinates.values.flatten

      coors_set.count
    end

    def solve_serialize
      Map.new(@input)
        .tap(&:find_antinode_coordinates_v2)
        .serialize
    end
  end
end

puts
# puts Day8::Part1.from_test_input_file.solve
# puts Day8::Part1.from_input_file.solve
# puts Day8::Part2.from_test_input_file.solve_serialize
# pp Day8::Part2.from_test_input_file.solve
puts Day8::Part2.from_input_file.solve
#
