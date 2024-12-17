class Map
  attr_reader :entries

  def self.new_from_input(input)
    new input.strip.split("\n").map(&:strip).map { |_| _.split("") }
  end

  def self.new_from_width_and_height(width, height)
    new Array.new(height) { Array.new(width) }
  end

  def initialize(array_of_arrays)
    @entries = array_of_arrays
  end

  def off_grid?(coordinate)
    x, y = coordinate.to_a

    x.negative? || y.negative? || x >= width || y >= height
  end

  def each_point_and_value(&block)
    return enum_for(:each_point_and_value) unless block_given?

    @entries.each.with_index do |line, y|
      line.each.with_index do |value, x|
        block.call Point[x, y], value
      end
    end
  end

  def each_row(&block)
    return enum_for(:each_row) unless block_given?

    @entries.each(&block)
  end

  def width = @width ||= @entries.first.length

  def height = @height ||= @entries.length

  def neighbors(point)
    {
      :up => point - Point[0, 1],
      :down => point + Point[0, 1],
      :left => point - Point[1, 0],
      :right => point + Point[1, 0],
    }.delete_if { |_, point| off_grid?(point) }
  end

  def neighbor(point, direction)
    point = neighbors(point)[direction]

    [point, value_at(point)]
  end

  def value_at(point) = @entries[point.y][point.x]

  def []=(point, value)
    @entries[point.y][point.x] = value
  end

  alias_method :set_value_at, :[]=
end

class Point
  def self.[](x, y)
    new(x, y)
  end

  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    to_a == other.to_a
  end

  def eql?(other)
    self == other
  end

  def to_a = [x, y]

  def +(other)
    self.class[@x + other.x, @y + other.y]
  end

  def -(other)
    self.class[@x - other.x, @y - other.y]
  end

  def hash = [x, y].hash

  def to_s = "(#{x},#{y})"
  def inspect = "Point #{x},#{y}"
end
