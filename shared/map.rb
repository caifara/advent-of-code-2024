class Map
  attr_reader :input

  def initialize(input)
    @input = input.strip.split("\n").map(&:strip).map { |_| _.split("") }
  end

  def off_grid?(coordinate)
    x, y = coordinate.to_a

    x.negative? || y.negative? || x >= width || y >= height
  end

  def each_point_and_value(&block)
    return enum_for(:each_point_and_value) unless block_given?

    @input.each.with_index do |line, y|
      line.each.with_index do |value, x|
        block.call Point[x, y], value
      end
    end
  end

  def width = @width ||= @input.first.length

  def height = @height ||= @input.length

  def neighbors(point)
    [point - Point[1, 0], point - Point[0, 1], point + Point[1, 0], point + Point[0, 1]]
      .reject { |_| off_grid?(_) }
  end

  def value_at(point) = @input[point.y][point.x]
end

class Point
  def self.[](x, y)
    new(x, y)
  end

  attr_reader :x, :y

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
