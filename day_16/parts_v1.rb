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

  def find_paths(point: @point, direction: @direction, tail: [])
    current_score = tail.sum(&:score)

    if (lowest_score = @points_and_scores[point]) && lowest_score < current_score
      print "X"
      return
    end

    tail.each do |rp|
      if (lowest_score = @points_and_scores[rp.point]) && lowest_score < rp.score
        print "Y"
        return
      end
    end

    @points_and_scores[point] = current_score
    puts @points_and_scores.length
    puts "#{current_score} for #{point}"

    @map.neighbors(point).each do |new_direction, new_point|
      next if new_point == tail.last&.point

      new_point_type = @map.value_at(new_point)

      next if new_point_type.is_a?(Reindeer)
      next if new_point_type.is_a?(Wall)

      new_tail = tail.dup

      case new_point_type
      when EndTile
        new_tail << ReindeerPosition.new(point: new_point, direction: new_direction, prev_dir: direction)

        score = new_tail.sum(&:score)

        @paths << new_tail

        if @lowest_score.nil? || score < @lowest_score
          @lowest_score = score
          @path = new_tail
        end
      when EmptySpace
        if new_tail.any? { |rp| rp.point == new_point }
          print "R"
        elsif @lowest_score && new_tail.sum(&:score) > @lowest_score
          print "L"
        else
          print "."
          new_tail << ReindeerPosition.new(point: new_point, direction: new_direction, prev_dir: direction)
          find_paths(point: new_point, direction: new_direction, tail: new_tail)
        end
      else raise "Unknown value: #{new_point}"
      end
    end
  end
end

class ReindeerPosition
  attr_reader :point

  def initialize(point:, direction:, prev_dir:)
    @point = point
    @direction = direction
    @prev_dir = prev_dir
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
