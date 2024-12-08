class Map
  attr_reader :input, :guard
  attr_accessor :obstacle_coordinates

  def initialize(input)
    @input = input.strip.split("\n").map(&:strip)

    @obstacle_coordinates, @guard = find_obstacle_and_guard_coordinates
  end

  def serialize
    guard_char = { right: ">", left: "<", up: "^", down: "v" }[@guard.direction]

    height.times.map do |y|
      width.times.map do |x|
        if @obstacle_coordinates.include?([x, y])
          "#"
        elsif x == @guard.x && y == @guard.y
          guard_char
        elsif @guard.guarded_coordinates.include?([x, y])
          "*"
        else
          "."
        end
      end.join
    end.join("\n")
  end

  def off_grid?(coordinate)
    x, y = coordinate

    x.negative? || y.negative? || x >= width || y >= height
  end

  def is_obstacle?(coordinate)
    @obstacle_coordinates.include?(coordinate)
  end

  private

  def find_obstacle_and_guard_coordinates
    guard = nil
    obstacles = []

    @input.each_with_index do |line, y|
      if !guard && x = line =~ />|<|\^|v/
        direction = { ">" => :right, "<" => :left, "^" => :up, "v" => :down }.fetch($&)
        guard = Guard.new(x, y, direction, self)
      end

      line.scan(/#/) do
        obstacles << [Regexp.last_match.begin(0), y]
      end
    end

    [obstacles, guard]
  end

  def width = @width ||= @input.first.length

  def height = @height ||= @input.length
end

class Guard
  attr_reader :x, :y, :guarded_coordinates

  def initialize(x, y, direction, map)
    @x = x
    @y = y
    @direction = direction
    @map = map

    @guarded_coordinates = Set.new([[@x, @y]])
    @loop = false
    @lines = Set.new([{ start: [@x, @y], direction: @direction }])
  end

  def move
    loop do
      nc = next_coordinate

      if @map.off_grid?(nc)
        @x = nil, @y = nil
        break
      elsif @map.is_obstacle?(nc)
        turn_right
        new_line = { start: [@x, @y], direction: @direction }

        if @lines.include?(new_line)
          @loop = true
          break
        end

        @lines << new_line
      else
        move_to nc
      end
    end
  end

  def loop? = @loop

  private

  def next_coordinate
    case @direction
    when :right then [@x + 1, @y]
    when :left then [@x - 1, @y]
    when :up then [@x, @y - 1]
    when :down then [@x, @y + 1]
    end
  end

  def move_to(coordinate)
    @x, @y = coordinate
    @guarded_coordinates << coordinate
  end

  def turn_right
    @direction = { right: :down, up: :right, left: :up, down: :left }[@direction]
  end
end
