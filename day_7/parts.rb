require_relative "../setup"

class Integer
  def concat(other)
    (self.to_s + other.to_s).to_i
  end
end

class Calibration
  def initialize(value, numbers)
    @value = value
    @numbers = numbers
  end

  def solvable?(operations = %i[+ *])
    all_operations = operations.repeated_permutation(@numbers.length - 1)

    all_operations.any? do |operation_set|
      operation_set = operation_set.to_enum
      numbers = @numbers.to_enum
      sum = numbers.next

      (@numbers.length - 1).times do
        sum = sum.send(operation_set.next, numbers.next)
      end

      sum == @value
    end
  end

  def solvable_with_concatenation? = solvable? %i[+ * concat]
end

module Day7
  class Part
    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").readlines

    def self.from_test_input_file = new Pathname.new(__dir__).join("test_input.txt").readlines

    def initialize(input)
      @input = input
    end
  end

  class Part1 < Part
    def solve
      @input.sum do |line|
        value, *numbers = line.scan(/\d+/).map(&:to_i)

        if Calibration.new(value, numbers).solvable?
          puts value

          value
        else
          0
        end
      end
    end
  end

  class Part2 < Part
    def solve
      @input.sum do |line|
        value, *numbers = line.scan(/\d+/).map(&:to_i)

        if Calibration.new(value, numbers).solvable_with_concatenation?
          puts value

          value
        else
          0
        end
      end
    end
  end
end

# puts Calibration.new(190, [10, 19]).solvable?

puts
# puts Day7::Part1.from_test_input_file.solve
puts Day7::Part2.from_input_file.solve
#
