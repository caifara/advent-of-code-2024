require_relative "../setup"
require_relative "maze"
require_relative "basic_runner"
require "base64"

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
  attr_accessor :shortest_path

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

  def cheat_run_2(cheat_point:, max_cheat_steps:, min_cheat_effect:)
    reachable_points = find_reachable_points(cheat_point:, max_cheat_steps:, min_cheat_effect:)

    travelled_steps_to_check = reachable_points
      .filter { |point| step_distance(cheat_point, point) <= max_cheat_steps }
      .map { |point| steps_saved(cheat_point, point) }
      .filter { |steps_count| steps_count >= min_cheat_effect }
  end

  private

  def find_reachable_points(cheat_point:, max_cheat_steps:, min_cheat_effect:)
    cheat_point_steps_travelled = travelled_steps(cheat_point)
    min_steps_travelled = cheat_point_steps_travelled + min_cheat_effect + 2

    index = 0
    reachable_points = []

    loop do
      point_to_check = point_by_travelled_steps(min_steps_travelled + index)
      break unless point_to_check

      step_distance = step_distance(cheat_point, point_to_check)

      reachable_points << point_to_check if step_distance <= max_cheat_steps

      index += 1
    end

    reachable_points
  end

  def point_by_travelled_steps(steps)
    @points_by_travelled_steps ||= @shortest_path.to_h { |rp| [rp.steps, rp.point] }
    @points_by_travelled_steps[steps]
  end

  def travelled_steps(point)
    @travelled_steps ||= @shortest_path.to_h { |rp| [rp.point, rp.steps] }
    @travelled_steps[point]
  end

  def step_distance(point1, point2)
    (point1.x - point2.x).abs + (point1.y - point2.y).abs
  end

  def steps_saved(from_point, to_point)
    travelled_steps(to_point) - travelled_steps(from_point) - step_distance(from_point, to_point)
  end
end

class Part
  def initialize(input)
    @maze = Maze.new_from_input(input)
  end
end

module Day20
  class Part1 < Part
    def solve
      normal_step_count = @maze.runner.run.length

      cheat_step_saves = []

      @maze.runner.shortest_path.each do |runner_position|
        point = runner_position.point

        @maze.runner.cheat_run(cheat_point: point).each do |steps_count|
          saved_steps = normal_step_count - steps_count
          next if saved_steps < 1

          cheat_step_saves << saved_steps
        end
      end

      cheat_step_saves.tally.sum { |saved_steps, count| saved_steps >= 100 ? count : 0 }
    end
  end

  class Part2 < Part
    def solve(max_cheat_steps:, min_cheat_effect:)
      @maze.runner.run

      possible_cheat_points = @maze.runner.shortest_path.map(&:point)
      possible_cheat_points = possible_cheat_points[0..-min_cheat_effect]

      steps_saved = possible_cheat_points.flat_map do |point|
        @maze.runner.cheat_run_2(cheat_point: point, max_cheat_steps:, min_cheat_effect:)
      end

      steps_saved.compact.sum
    end
  end
end

# puts Day20::Part1.from_test_input_file.solve
# puts Day20::Part1.from_input_file.solve
# puts Day20::Part2.from_test_input_file.prerun
# puts Day20::Part2.from_test_input_file.solve(max_cheat_steps: 2, min_cheat_effect: 2)
# puts Day20::Part2.from_test_input_file.solve(max_cheat_steps: 20, min_cheat_effect: 50)
puts Day20::Part2.from_input_file.solve(max_cheat_steps: 20, min_cheat_effect: 100)
