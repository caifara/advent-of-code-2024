require_relative "../setup"
require_relative "map"

module Moveable
  def move(direction)
    point, neighbor = @map.neighbor(@point, direction)

    neighbor.move(direction)

    @map[point] = self
    @map[@point] = EmptySpace.new
    @point = point
  end

  def moveable?(direction)
    point, neighbor = @map.neighbor(@point, direction)

    neighbor.moveable?(direction)
  end
end

class EmptySpace
  def moveable?(_) = true

  def move(_) = nil

  def to_s = "."
end

class Mapthing
  attr_reader :point

  def initialize(map:, point:)
    @map = map
    @point = point
  end
end

class Wall < Mapthing
  def moveable?(_) = false

  def move(_) = raise

  def to_s = "#"
end

class Robot < Mapthing
  include Moveable

  def move_all(moves)
    moves.each do |direction|
      move(direction) if moveable?(direction)
    end
  end

  def to_s = "@"
end

class DoubleBox
  attr_reader :boxes

  def initialize(point1:, point2:, map:)
    @boxes = [
      Box.new(map:, point: point1, double_box: self),
      Box.new(map:, point: point2, double_box: self),
    ]
  end

  def moveable?(direction)
    case direction
    when :left
      boxes.first.moveable?(:left, act_as_single_box: true)
    when :right
      boxes.last.moveable?(:right, act_as_single_box: true)
    when :up, :down
      boxes.all? { |box| box.moveable?(direction, act_as_single_box: true) }
    end
  end

  def move(direction)
    case direction
    when :left, :up, :down
      boxes.each { |box| box.move(direction, act_as_single_box: true) }
    when :right
      boxes.reverse.each { |box| box.move(direction, act_as_single_box: true) }
    end
  end

  def right_part?(box) = @boxes.last == box
end

class Box < Mapthing
  include Moveable

  def initialize(double_box: nil, **)
    @double_box = double_box

    super(**)
  end

  def move(direction, act_as_single_box: false)
    if @double_box && !act_as_single_box
      @double_box.move(direction)
    else
      super(direction)
    end
  end

  def moveable?(direction, act_as_single_box: false)
    if @double_box && !act_as_single_box
      @double_box.moveable?(direction)
    else
      super(direction)
    end
  end

  def other_box
    @double_box.boxes.find { |box| box != self }
  end

  def gps_coords
    return 0 if @double_box && @double_box.right_part?(self)

    @point.y * 100 + @point.x
  end

  def to_s
    return "O" unless @double_box

    @double_box.boxes.first == self ? "[" : "]"
  end
end

class Warehouse < Map
  attr_reader :robot

  def initialize(input)
    super

    @robot = nil

    transform_entries_and_values
  end

  def serialize = @entries.map(&:join)

  alias to_s serialize

  def sum_box_gps_coords
    each_point_and_value
      .map { |_, thing| thing }
      .select { |thing| thing.is_a?(Box) }
      .sum { |box| box.gps_coords }
  end

  private

  def transform_entries_and_values
    each_point_and_value do |point, v|
      value = case v
        when "." then EmptySpace.new
        when "#" then Wall.new(map: self, point:)
        when "@" then Robot.new(map: self, point:)
        when "O" then Box.new(map: self, point:)
        else raise "Unknown value: #{v}"
        end

      @robot = value if value.is_a?(Robot)

      set_value_at(point, value)
    end
  end
end

class WarehouseP2 < Warehouse
  CHAR_MAP = {
    "." => "..",
    "#" => "##",
    "@" => "@.",
    "O" => "[]",
  }.freeze

  def initialize(input)
    input = widen(input)

    super(input)
  end

  private

  def widen(input)
    input.map do |line|
      line.map { |char| CHAR_MAP[char] }
    end
  end

  def transform_entries_and_values
    @entries = @entries.map.with_index do |line, y|
      line.flat_map.with_index do |v, x|
        point = Point[x, y]
        point1 = Point[point.x * 2, point.y]
        point2 = point1 + Point[1, 0]

        value1, value2 = case v
          when ".." then [EmptySpace.new, EmptySpace.new]
          when "##" then [Wall.new(map: self, point: point1), Wall.new(map: self, point: point2)]
          when "@." then [Robot.new(map: self, point: point1), EmptySpace.new]
          when "[]" then DoubleBox.new(point1:, point2:, map: self).boxes
          else raise "unknown value: #{v}"
          end

        @robot = value1 if value1.is_a?(Robot)

        [value1, value2]
      end
    end
  end
end

class Part
  MOVE_MAP = { ">" => :right, "<" => :left, "^" => :up, "v" => :down }.freeze

  def initialize(input)
    map, moves = input.split("\n\n").map(&:strip)

    @moves = moves.split("\n").map(&:strip).join("").split("").map { |move| MOVE_MAP[move] }

    @warehouse = warehouse_class.new_from_input(map)
  end

  def solve
    @warehouse.robot.move_all(@moves)

    @warehouse.sum_box_gps_coords
  end
end

module Day15
  class Part1 < Part
    private

    def warehouse_class = Warehouse
  end

  class Part2 < Part
    private

    def warehouse_class = WarehouseP2
  end
end

# puts Day15::Part1.from_test_input_file.solve
puts Day15::Part1.from_input_file.solve
# puts Day15::Part2.from_test_input_file.solve
puts Day15::Part2.from_input_file.solve
