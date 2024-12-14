require_relative "../setup"
require_relative "../shared/map"

class Robot
  attr_reader :location

  def initialize(location:, velocity:, map:)
    @location = location
    @velocity = velocity
    @map = nil
  end

  def set_map(map) = @map = map

  def tick
    @location += @velocity

    @location.x += @map.width if @location.x < 0
    @location.x -= @map.width if @location.x >= @map.width

    @location.y += @map.height if @location.y < 0
    @location.y -= @map.height if @location.y >= @map.height
  end
end

class Part
  def initialize(input)
    @map = nil
    @robots = input.split("\n").map do |line|
      x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)

      Robot.new(location: Point[x, y], velocity: Point[vx, vy], map: @map)
    end
  end

  def set_map(width: 101, height: 103)
    @map = Map.new_from_width_and_height(width, height)
    @robots.each { |robot| robot.set_map(@map) }
  end

  def serialize
    robot_location_counts = @robots.map { |robot| robot.location }.tally

    @map.height.times.map do |y|
      @map.width.times.map do |x|
        count = robot_location_counts[Point[x, y]] || 0
        count.positive? ? count.to_s : "."
      end.join("")
    end.join("\n")
  end

  def tick
    @robots.each(&:tick)
  end
end

module Day14
  class Part1 < Part
    def solve(steps = 100)
      steps.times { tick }
      safety_factor
    end

    private

    def safety_factor
      robot_location_counts = @robots.map { |robot| robot.location }.tally

      kw = [
        [0, 0],
        [0, 0],
      ]

      @map.each_point_and_value do |point, _|
        robot_count = robot_location_counts[point]

        next unless robot_count

        kw_row_mid = (@map.height - 1) / 2
        kw_row = if point.y < kw_row_mid
            0
          elsif point.y > kw_row_mid
            1
          end
        kw_col_mid = (@map.width - 1) / 2
        kw_col = if point.x < kw_col_mid
            0
          elsif point.x > kw_col_mid
            1
          end

        next if kw_row.nil? || kw_col.nil?

        puts "#{point} -> #{kw_row},#{kw_col}"

        kw[kw_row][kw_col] += robot_count
      end

      kw.flatten.reduce(:*)
    end
  end

  class Part2 < Part
    def solve
      10000000.times do |step|
        step += 1

        tick

        serialized = serialize

        if serialized.match?(/111111111111/)
          puts "found one on step #{step}"

          File.open("#{__dir__}/output_#{step}.txt", "w") do |file|
            file.write "#{step}\n#{serialized}\n\n"
          end
        end
      end
    end
  end
end

# puts Day14::Part1.from_input_file.tap(&:set_map).solve
puts Day14::Part2.from_input_file.tap(&:set_map).solve
