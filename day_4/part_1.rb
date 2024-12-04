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

    def all_matrices(matrix)
      Enumerator.new do |yielder|
        yielder << matrix
        yielder << matrix.transpose
        yielder << diagonals(matrix, :right)
        yielder << diagonals(matrix, :left)
      end
    end

    def diagonals(matrix, direction)
      matrix = direction == :right ? matrix.map(&:dup) : matrix.map(&:reverse)

      padding = "*"
      row_count = matrix.length

      shifted_matrix = matrix.map.with_index do |line, i|
        i.times do
          line.push(padding)
        end

        (row_count - i).times do
          line.unshift(padding)
        end

        line
      end

      shifted_matrix
        .transpose
        .map { |line| line.join.gsub(padding, "").split("") }
    end
  end
end

puts Day4::Part1.from_input_file.solve
