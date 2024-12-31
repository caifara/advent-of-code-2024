require_relative "../setup"
require_relative "map"

class Keypad < Map
  def initialize(entries)
    @entries = entries
  end

  def position_of(key)
    each_point_and_value do |point, value|
      return point if value == key
    end
  end

  def avoid_point
    position_of(nil)
  end
end

NUMERIC_KEYPAD = Keypad.new(
  [
    [7, 8, 9],
    [4, 5, 6],
    [1, 2, 3],
    [nil, 0, :A],
  ]
)

DIRECTIONAL_KEYPAD = Keypad.new(
  [
    [nil, :up, :A],
    [:left, :down, :right],
  ]
)

class RobotArm
  def initialize(keypad, nr: 0)
    @keypad = keypad
    @current_position = keypad.position_of(:A)
    @nr = nr
  end

  def direction_sets_for(*keys)
    keys.map do |key|
      new_position = @keypad.position_of(key)

      direction_sets(from_point: @current_position, to_point: new_position).tap do |movements|
        @current_position = new_position
      end
    end
  end

  def direction_sets_for_key_sets_w_alternatives(key_sets_w_alternatives)
    key_sets_w_alternatives.map do |key_set_w_alternatives|
      key_set_w_alternatives.flat_map do |keys|
        input = direction_sets_for(*keys)

        input.reduce(&:product).map(&:flatten).tap do |direction_sets|
          # puts "/reduce #{@nr}"
          # puts
          # pp keys
          # direction_sets.each { |direction_set| puts instr_to_s direction_set }
        end
      end
    end
  end

  private

  def direction_sets(from_point:, to_point:)
    @direction_sets ||= {}
    @direction_sets[[from_point, to_point]] ||= begin
        puts "#{from_point} -> #{to_point}"
        x_diff = to_point.x - from_point.x
        y_diff = to_point.y - from_point.y

        directions = (([x_diff.positive? ? :right : :left] * x_diff.abs) + ([y_diff.positive? ? :down : :up] * y_diff.abs)).flatten

        direction_sets = [directions, directions.reverse].uniq.select { |directions| allowed_directions?(from_point:, directions:) }

        direction_sets.map { |directions| directions + [:A] }
      end
  end

  def allowed_directions?(from_point:, directions:)
    current_point = from_point

    directions.none? do |direction|
      current_point = @keypad.neighbor_point(current_point, direction)

      current_point == @keypad.avoid_point
    end
  end
end

class Part
  def initialize(input)
    @codes = input.split("\n").map(&:strip)
  end

  def solve
    sum = @codes.sum do |code|
      digits = code.scan(/\d/).map(&:to_i)

      digits.map(&:to_s).join.to_i.tpp * directions_for(*digits, :A).length.tpp
    end

    puts sum
  end
end

module Day21
  class Part1 < Part
    def directions_for(*code)
      arm = RobotArm.new(NUMERIC_KEYPAD)
      arm2 = RobotArm.new(DIRECTIONAL_KEYPAD, nr: 2)
      arm3 = RobotArm.new(DIRECTIONAL_KEYPAD, nr: 3)

      arm.direction_sets_for(*code)
        .then { arm2.direction_sets_for_key_sets_w_alternatives(_1) }
        .then { arm3.direction_sets_for_key_sets_w_alternatives(_1) }
        .then { |direction_sets| direction_sets.reduce(&:product).map(&:flatten).min_by(&:length) }
    end
  end

  class Part2 < Part
    def directions_for(*code)
      arm = RobotArm.new(NUMERIC_KEYPAD)

      dir_arms = 25.times.map { RobotArm.new(DIRECTIONAL_KEYPAD, nr: _1) }

      base_directions = arm.direction_sets_for(*code)

      dir_arms.reduce(base_directions) { |directions, dir_arm| dir_arm.direction_sets_for_key_sets_w_alternatives(directions) }
        .then { |direction_sets| direction_sets.reduce(&:product).map(&:flatten).min_by(&:length) }
    end
  end
end

# Day21::Part1.from_test_input_file.directions_for(0, 2, 9, :A)
Day21::Part1.from_test_input_file.solve
# puts Day21::Part1.from_test_input_file.solve
# puts Day21::Part1.from_input_file.solve
# puts Day21::Part2.from_input_file.solve
# puts Day21::Part2.from_test_input_file.solve
# puts Day21::Part2.from_test_input_file.solve
