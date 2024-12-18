require_relative "../setup"

class Instruction
  OPCODES = {
    0 => ->(operand) { @a = (@a / 2 ** combo(operand)); nil },
    1 => ->(operand) { @b = @b ^ operand; nil },
    2 => ->(operand) { @b = combo(operand) % 8; nil },
    3 => ->(operand) { (@a != 0 && (@pointer = operand - 2)); nil },
    4 => ->(operand) { @b = @b ^ @c; nil },
    5 => ->(operand) { combo(operand) % 8 },
    6 => ->(operand) { @b = (@a / 2 ** combo(operand)); nil },
    7 => ->(operand) { @c = (@a / 2 ** combo(operand)); nil },
  }

  OPERANDS = {
    0 => -> { 0 },
    1 => -> { 1 },
    2 => -> { 2 },
    3 => -> { 3 },
    4 => -> { @a },
    5 => -> { @b },
    6 => -> { @c },
  }

  attr_accessor :a, :b, :c

  def initialize(a: nil, b: nil, c: nil, prg: nil)
    @a = a
    @b = b
    @c = c
    @prg = prg

    @pointer = 0
  end

  def execute
    result = []

    loop do
      # puts @pointer

      opcode = @prg[@pointer]
      operand = @prg[@pointer + 1]

      break if opcode.nil?

      result << instance_exec(operand, &OPCODES.fetch(opcode))

      # puts "opcode: #{opcode}, operand: #{operand}"
      # puts "result: #{result}"
      # puts

      @pointer += 2
    end

    result.compact
  end

  def registers
    { a: @a, b: @b, c: @c }
  end

  def combo(operand) = instance_exec(&OPERANDS.fetch(operand))
end

class Part
  def initialize(input)
    registers, program = input.split("\n\n").map(&:strip)

    a, b, c = registers.scan(/\d+/).map(&:to_i)
    prg = program.scan(/\d/).map(&:to_i)

    @instruction = Instruction.new(a:, b:, c:, prg:)
  end
end

module Day17
  class Part1 < Part
    def solve
      @instruction.execute.join(",")
    end
  end

  class Part2 < Part
    def solve
    end
  end
end

# puts Day17::Part1.from_test_input_file.solve
puts Day17::Part1.from_input_file.solve
# puts Day17::Part2.from_test_input_file.solve
# puts Day17::Part2.from_input_file.solve
