class Map
  attr_reader :input, :antinode_coordinates, :antennas_w_coordinates

  def initialize(input)
    @input = input.strip.split("\n").map(&:strip)

    @antennas_w_coordinates = find_antenna_coordinates
    @antinode_coordinates = Set.new
  end

  def find_antinode_coordinates_v1
    @antennas_w_coordinates.each do |antenna_name, a_coor|
      a_coor.combination(2) do |point1, point2|
        diff = point1 - point2

        add_antinode_coordinates(point2 - diff, antenna_name)
        add_antinode_coordinates(point1 + diff, antenna_name)
      end
    end
  end

  def find_antinode_coordinates_v2
    @antennas_w_coordinates.each do |antenna_name, a_coor|
      a_coor.combination(2) do |point1, point2|
        diff = point1 - point2

        antinode_coor = point2

        loop do
          antinode_coor -= diff

          break if off_grid?(antinode_coor)

          @antinode_coordinates << antinode_coor
        end

        antinode_coor = point1

        loop do
          antinode_coor += diff

          break if off_grid?(antinode_coor)

          @antinode_coordinates << antinode_coor
        end
      end
    end
  end

  def serialize
    coordinates_w_antennas = @antennas_w_coordinates.map do |name, coordinates|
      coordinates.map { |c| [c, name] }
    end.flatten(1).to_h

    height.times.map do |y|
      width.times.map do |x|
        if name = coordinates_w_antennas[Coor[x, y]]
          name
        elsif @antinode_coordinates.include?(Coor[x, y])
          "#"
        else
          "."
        end
      end.join
    end.join("\n")
  end

  private

  def find_antenna_coordinates
    Hash.new { |h, k| h[k] = [] }.tap do |a_w_c|
      @input.each_with_index do |line, y|
        line.scan(/[^\.]/) do |antenna_name|
          a_w_c[antenna_name] << Coor[Regexp.last_match.begin(0), y]
        end
      end
    end
  end

  def add_antinode_coordinates(coor, antenna_name)
    return if off_grid?(coor)

    @antinode_coordinates << coor
  end

  def off_grid?(coordinate)
    x, y = coordinate.to_a

    x.negative? || y.negative? || x >= width || y >= height
  end

  def width = @width ||= @input.first.length

  def height = @height ||= @input.length
end

class Coordinate
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

  def inspect = "coor #{x},#{y}"
end

Coor = Coordinate
