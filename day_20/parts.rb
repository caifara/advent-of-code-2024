require_relative "../setup"
require_relative "maze"
require_relative "basic_runner"

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

class Runner < BasicRunner
  def cheat_run(cheat_point:)
    puts "cheat_point: #{cheat_point}"
    normal_points = @shortest_path.map(&:point)

    cheat_exit_step_counts = @map.neighbors(cheat_point).flat_map do |_dir, point1|
      next unless @map.value_at(point1).is_a?(Wall)

      @map.neighbors(point1).map do |_dir, point2|
        next if point2 == cheat_point

        case @map.value_at(point2)
        when EndTile then 2
        when EmptySpace
          next unless normal_points.include?(point2)

          puts "found shortcut #{point1} -> #{point2}"

          1 + steps_from(point2)
        end
      end
    end.compact

    cheat_exit_step_counts.map { |steps_count| steps_count + steps_until(cheat_point) }
  end

  def cheat_run_2(cheat_point:, max_dist: 20)
    puts "cheat_point: #{cheat_point}"

    normal_points = @shortest_path.map(&:point)

    cheat_exit_step_counts = 1.upto(max_dist).map do |dist|
      @map.points_on_step_distance_from(cheat_point, dist).map do |point|
        case @map.value_at(point)
        when EndTile then dist
        when EmptySpace
          next unless normal_points.include?(point)

          puts "found shortcut #{cheat_point} -> #{point}"

          dist + steps_from(point)
        end
      end.tpp
    end.flatten.compact

    cheat_exit_step_counts.map { |steps_count| steps_count + steps_until(cheat_point) }
  end

  private

  def steps_until(point)
    i = shortest_path.index { |rp| rp.point == point }

    @shortest_path[0..i].length
  end

  def steps_from(point)
    i = shortest_path.index { |rp| rp.point == point }

    @shortest_path[i..].length
  end
end

class Part
  def initialize(input)
    @maze = Maze.new_from_input(input)
  end

  def solve(run_method: :cheat_run)
    normal_step_count = @maze.runner.run.length

    cheat_step_saves = []

    @maze.runner.shortest_path.each do |runner_position|
      point = runner_position.point

      @maze.runner.send(run_method, cheat_point: point).each do |steps_count|
        saved_steps = normal_step_count - steps_count
        next if saved_steps < 1

        cheat_step_saves << saved_steps
      end
    end

    cheat_step_saves.tally.sum { |saved_steps, count| saved_steps >= 100 ? count : 0 }
  end
end

module Day20
  class Part1 < Part
  end

  class Part2 < Part
    def solve
      super(run_method: :cheat_run_2)
    end
  end
end

# puts Day20::Part1.from_test_input_file.solve
# puts Day20::Part1.from_input_file.solve
puts Day20::Part2.from_test_input_file.solve
# puts Day20::Part2.from_input_file.solve
