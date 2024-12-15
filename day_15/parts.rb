require_relative "../setup"
require_relative "map"

module Movable
  def move(direction)
    point, neighbor = @map.neighbor(@point, direction)

    if neighbor.move(direction)
      @map[point] = self
      @map[@point] = EmptySpace.new
      @point = point
    end
  end
end

class EmptySpace
  def move(_) = true
end

class Mapthing
  def initialize(map:, point:)
    @map = map
    @point = point
  end
end

class Wall < Mapthing
  def move(_) = false
end

class Robot < Mapthing
  include Movable

  def move_all(moves)
    moves.each do |direction|
      move(direction)
    end
  end

  def move(direction)
    super

    # puts
    # puts direction
    # puts @map.serialize
  end
end

class Box < Mapthing
  include Movable

  def gps_coords
    @point.y * 100 + @point.x
  end
end

class Warehouse < Map
  attr_reader :robot

  def initialize(input)
    super

    @robot = nil

    identify_values
  end

  def serialize
    @entries.map do |line|
      line.map do |value|
        case value
        when EmptySpace then "."
        when Wall then "#"
        when Robot then "@"
        when Box then "O"
        end
      end.join("")
    end.join("\n")
  end

  def sum_box_gps_coords
    each_point_and_value
      .map { |_, thing| thing }
      .select { |thing| thing.is_a?(Box) }
      .sum { |box| box.gps_coords }
  end

  private

  def identify_values
    each_point_and_value do |point, v|
      value = case v
        when "." then EmptySpace.new
        when "#" then Wall.new(map: self, point:)
        when "@" then Robot.new(map: self, point:)
        when "O" then Box.new(map: self, point:)
        else raise
        end

      @robot = value if value.is_a?(Robot)

      set_value_at(point, value)
    end
  end
end

class Part
  MOVE_MAP = { ">" => :right, "<" => :left, "^" => :up, "v" => :down }.freeze

  def initialize(input)
    map, moves = input.split("\n\n").map(&:strip)

    @moves = moves.split("\n").map(&:strip).join("").split("").map { |move| MOVE_MAP[move] }
    @warehouse = Warehouse.new_from_input(map)
  end
end

module Day15
  class Part1 < Part
    def solve
      @warehouse.robot.move_all(@moves)

      @warehouse.sum_box_gps_coords
    end
  end

  class Part2 < Part
  end
end

# puts Day15::Part1.from_test_input_file.solve
puts Day15::Part1.from_input_file.solve
# puts Day15::Part2.from_input_file.solve
