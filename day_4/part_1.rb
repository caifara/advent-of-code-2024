require_relative "../setup"

module Day4
  class Part1
    def initialize(input)
      @base_matrix = input.split("\n").map(&:strip).map { |line| line.split("") }
    end

    def solve
      all_matrices(@base_matrix).sum do |matrix|
        matrix.sum do |line|
          line.join.scan("XMAS").length + line.join.scan("SAMX").length
        end
      end
    end

    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    private

    def diagonals(matrix, direction)
      matrix = direction == :right ? matrix.map(&:dup) : matrix.map(&:reverse)

      column_count = matrix.first.length
      row_count = matrix.length

      diagonals = 0.upto(column_count - 1).map do |first_column_index|
        diagonal_from(matrix, 0, first_column_index).flatten.compact
      end

      diagonals + 1.upto(row_count - 1).map do |first_row_index|
        diagonal_from(matrix, first_row_index, 0).flatten.compact
      end
    end

    def diagonal_from(matrix, row_index, column_index)
      value = matrix.dig(row_index, column_index)

      if value
        [value, diagonal_from(matrix, row_index + 1, column_index + 1)]
      else
        nil
      end
    end

    def all_matrices(matrix)
      Enumerator.new do |yielder|
        yielder << matrix
        yielder << matrix.transpose
        yielder << diagonals(matrix, :right)
        yielder << diagonals(matrix, :left)
      end
    end
  end
end

require "benchmark"

time = Benchmark.measure do
  10.times do
    puts Day4::Part1.from_input_file.solve
  end
end
puts time.real
