require_relative "../setup"
require_relative "map"

def clear_and_show(str)
  system "clear"
  puts str
end

class EmptySpace
  def to_s = "."
end

class Wall
  def to_s = "#"
end

class EndTile
  def to_s = "E"
end

class Runner
  attr_reader :paths

  def initialize(map:, point:)
    @map = map
    @point = point

    @paths = []
    @shortest_path = nil

    @points_and_tails = {}
  end

  def shortest_path
    find_paths

    puts @map.serialize(add_points: @shortest_path.map(&:point), mark: "O")

    @shortest_path
  end

  def to_s = "S"

  private

  def find_paths
    paths = [[RunnerPosition.new(point: @point, tail: [])]]

    puts @map.serialize

    until paths.empty?
      puts "paths: #{paths.length}"

      paths = paths
        .flat_map { |tail| next_positions(tail:) }
        .compact
    end
  end

  def next_positions(tail:)
    last_position = tail.last

    last_point = last_position.point

    @map.neighbors(last_point).map do |_dir, new_point|
      new_point_type = @map.value_at(new_point)

      next if new_point_type.is_a?(Runner)
      next if new_point_type.is_a?(Wall)

      case new_point_type
      when EndTile
        new_tail = (tail + [RunnerPosition.new(point: new_point, tail:)])

        tail_length = new_tail.length

        @paths << new_tail

        if @shortest_path.nil? || tail_length < @shortest_path.length
          @shortest_path = new_tail
        end

        nil
      when EmptySpace
        if tail.any? { |rp| rp.point == new_point }
          nil
        elsif @shortest_path && tail.length > @shortest_path.length
          nil
        else
          new_tail = tail + [RunnerPosition.new(point: new_point, tail:)]

          if new_tail.any? { |rp| (shortest_path = @points_and_tails[rp.point]) && shortest_path != rp.path }
            # pp new_tail.map { |rp| [rp.point, rp.cumulative_score, @points_and_tails[rp.point]] }
            # clear_and_show @map.serialize(add_points: new_tail.map(&:point), mark: "§")
            # puts "aborting #{new_tail.map(&:point)} got lower score"
            nil
          else
            @points_and_tails[new_point] = new_tail

            new_tail
          end
        end
      else raise "Unknown value: #{new_point}"
      end
    end
  end
end

class RunnerPosition
  attr_reader :point, :tail

  def initialize(point:, tail:)
    @point = point
    @tail = tail
  end

  def path
    @tail + [self]
  end

  def to_s = "#{@point}, #{@tail.length}"
end

class MemorySpace < Map
  attr_reader :runner

  def initialize(input)
    super

    @runner = Runner.new(map: self, point: Point[0, 0])

    transform_entries_and_values
  end

  def serialize(add_points: [], mark: "O")
    @entries.map.with_index do |row, y|
      row.map.with_index do |v, x|
        if add_points.include?(Point[x, y])
          mark
        else
          v.to_s
        end
      end.join
    end.join("\n")
  end

  def corrupt(corrupted_bytes)
    corrupted_bytes.each do |x, y|
      @entries[y][x] = Wall.new
    end
  end

  private

  def transform_entries_and_values
    each_point_and_value do |point, v|
      value = case point
        when Point[0, 0] then @runner
        when Point[width - 1, height - 1] then EndTile.new
        else EmptySpace.new
        end

      set_value_at(point, value)
    end
  end
end

class Part
end

module Day18
  class Part1 < Part
    def initialize(input)
      @corrupted_bytes = input.split("\n").map { |line| line.scan(/\d+/).map(&:to_i) }
    end

    def setup_memory_space(w, h)
      @memory_space = MemorySpace.new_from_width_and_height(w + 1, h + 1)
    end

    def corrupt(limit)
      @memory_space.corrupt(@corrupted_bytes[0...limit])
    end

    def solve
      @memory_space.runner.shortest_path.length - 1
    end
  end

  class Part2 < Part
    def solve
    end
  end
end

# puts Day18::Part1.from_test_input_file.tap { |i| i.setup_memory_space(6, 6) }.tap { |i| i.corrupt(12) }.solve
puts Day18::Part1.from_input_file.tap { |i| i.setup_memory_space(70, 70) }.tap { |i| i.corrupt(1024) }.solve
# puts Day18::Part1.from_test_input_file.tap { |i| i.setup_memory_space(6, 6) }.tap { |i| i.corrupt(12) }.solve
# puts Day18::Part2.from_input_file.solve
