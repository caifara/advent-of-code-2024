require_relative "../setup"

module Day6
  class Part1
    GUARD_PATTERN = />|<|\^|v/.freeze

    def initialize(input)
      @input = input
      @map_anti_clockwise_turns = 0
    end

    def solve
      result_map.scan("*").length
    end

    def result_map
      face_right

      while guard_on_map?
        move_until_obstacle
        turn_map_anti_clockwise
      end

      (4 - @map_anti_clockwise_turns % 4).times { turn_map_anti_clockwise }

      @input
    end

    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    private

    def face_right
      return if @input.include?(">")

      turns = case @input
        when /v/ then 1
        when /</ then 2
        when /^/ then 3
        else raise
        end

      turns.times { turn_map_anti_clockwise }

      @input = @input.sub(GUARD_PATTERN, ">")
    end

    def guard_on_map? = @input.match(GUARD_PATTERN)

    def facing_obstacle? = @input.include?(">#")

    def move_until_obstacle
      @input = @input.split("\n").map do |line|
        if line.include?(">")
          index_of_guard = line.index(">")

          if part_index_of_obstacle = line[index_of_guard..].index("#")
            index_of_obstacle = index_of_guard + part_index_of_obstacle

            line[0...index_of_guard] +
              "*" * (index_of_obstacle - index_of_guard - 1) + ">" +
              line[index_of_obstacle..]
          else
            line[0...index_of_guard] + "*" * (line.length - index_of_guard)
          end
        else
          line
        end
      end.join("\n")
    end

    def turn_map_anti_clockwise
      @map_anti_clockwise_turns += 1
      @input = @input.split("\n").map { |line| line.split("").reverse }.transpose.map(&:join).join("\n")
    end
  end
end

puts Day6::Part1.from_input_file.solve
