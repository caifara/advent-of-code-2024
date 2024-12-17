require_relative "../setup"
require_relative "map"

class EmptySpace
  def to_s = "."
end

class Wall
  def to_s = "#"
end

class EndTile
  def to_s = "E"
end

class Reindeer
  def initialize(map:, point:, direction:)
    @map = map
    @point = point
    @direction = direction

    @paths = []
    @lowest_score = nil

    @points_and_scores = {}
  end

  def move
    find_paths

    [@path, @lowest_score]
  end

  def to_s = "S"

  private

  def find_paths
    paths = [[ReindeerPosition.new(point: @point, direction: @direction, prev_dir: @direction, tail: [])]]

    until paths.empty?
      puts "paths: #{paths.length}"
      # puts "scores for #{@points_and_scores[Point[5, 137]]}"
      # puts
      # paths.each do |path|
      #   puts path.map(&:point).join(" -> ")
      #   puts
      # end

      paths = paths
        .flat_map { |tail| next_positions(tail:) }
        .compact
    end
  end

  def next_positions(tail:)
    last_position = tail.last

    last_point = last_position.point
    direction = last_position.direction

    @map.neighbors(last_point).map do |new_direction, new_point|
      next if Set.new([:up, :down]) == Set.new([direction, new_direction])
      next if Set.new([:left, :right]) == Set.new([direction, new_direction])

      new_point_type = @map.value_at(new_point)

      next if new_point_type.is_a?(Reindeer)
      next if new_point_type.is_a?(Wall)

      case new_point_type
      when EndTile
        new_tail = (tail + [ReindeerPosition.new(point: new_point, direction: new_direction, prev_dir: direction, tail:)]).tap(&:shift)

        score = new_tail.sum(&:score)

        @paths << new_tail

        if @lowest_score.nil? || score < @lowest_score
          @lowest_score = score
          @path = new_tail
        end

        nil
      when EmptySpace
        if tail.any? { |rp| rp.point == new_point }
          nil
        elsif @lowest_score && tail.sum(&:score) > @lowest_score
          nil
        else
          new_tail = tail + [ReindeerPosition.new(point: new_point, direction: new_direction, prev_dir: direction, tail:)]

          if new_tail.any? { |rp| (lowest_score = @points_and_scores[rp.point]) && lowest_score < rp.cumulative_score }
            # puts "aborting path, got lower score"
            nil
          else
            @points_and_scores[new_point] = new_tail.last.cumulative_score

            new_tail
          end
        end
      else raise "Unknown value: #{new_point}"
      end
    end
  end
end

class ReindeerPosition
  attr_reader :point, :direction

  def initialize(point:, direction:, prev_dir:, tail:)
    @point = point
    @direction = direction
    @prev_dir = prev_dir
    @tail = tail
  end

  def score
    @score ||= begin
        degrees = {
          :up => 0,
          :right => 90,
          :down => 180,
          :left => 270,
        }

        turn_score = case (degrees[@direction] - degrees[@prev_dir]).abs
          when 0 then 0
          when 90 then 1000
          when 180 then 2000
          when 270 then 1000
          else raise
          end

        turn_score + 1
      end
  end

  def cumulative_score
    score + (@tail.last&.cumulative_score || 0)
  end

  def to_s = "#{@point}, #{@direction}"
end

class Maze < Map
  attr_reader :reindeer

  def initialize(input)
    super

    @reindeer = nil

    transform_entries_and_values
  end

  def serialize = @entries.map(&:join)

  private

  def next_points(point)
  end

  def transform_entries_and_values
    each_point_and_value do |point, v|
      value = case v
        when "." then EmptySpace.new
        when "#" then Wall.new
        when "E" then EndTile.new
        when "S" then Reindeer.new(map: self, point:, direction: :right)
        else raise "Unknown value: #{v}"
        end

      @reindeer = value if value.is_a?(Reindeer)

      set_value_at(point, value)
    end
  end
end

class Part
  def initialize(input)
    @maze = maze_class.new_from_input(input.strip)
  end

  def solve
    @maze.reindeer.move
  end
end

module Day16
  class Part1 < Part
    private

    def maze_class = Maze
  end

  class Part2 < Part
    private

    def maze_class = MazeP2
  end
end

# puts Day16::Part1.from_test_input_file.solve
puts Day16::Part1.from_input_file.solve
# puts Day16::Part2.from_test_input_file.solve
# puts Day16::Part2.from_input_file.solve
