require_relative "../setup"

class Machine
  def self.from_input(machine_input)
    a, b, prize = machine_input.split("\n")
    a1, a2 = a.scan(/\d+/).map { Rational(_1) }
    b1, b2 = b.scan(/\d+/).map { Rational(_1) }
    prize1, prize2 = prize.scan(/\d+/).map { Rational(_1) }

    new(a1, b1, prize1, a2, b2, prize2)
  end

  def initialize(a1, b1, prize1, a2, b2, prize2)
    @a1, @b1, @prize1 = a1, b1, prize1
    @a2, @b2, @prize2 = a2, b2, prize2
    @solution = nil
  end

  def spending
    winnable? ? a * 3 + b : 0
  end

  private

  def a = solution.first

  def b = solution.last

  def solution
    @solution ||= begin
        b = (@prize2 - @a2 * @prize1 / @a1) / (-@a2 * @b1 / @a1 + @b2)
        a = (@prize1 - @b1 * b) / @a1

        [a, b]
      end
  end

  def winnable?
    a.to_i == a && b.to_i == b
  end
end

module Day13
  class ::Part
    def solve = machines.sum(&:spending)

    private

    def machines
      machines_input = @input.split("\n\n")
      machines_input.map do |machine_input|
        machine_class.from_input(machine_input)
      end
    end
  end

  class Part1 < Part
    def machine_class = Machine
  end

  class Part2 < Part
    class P2Machine < Machine
      def initialize(*args)
        super

        @prize1 += 10000000000000
        @prize2 += 10000000000000
      end
    end

    def machine_class = P2Machine
  end
end

puts
puts Day13::Part1.from_input_file.solve
puts Day13::Part2.from_input_file.solve
