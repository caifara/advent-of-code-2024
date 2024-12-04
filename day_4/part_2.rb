require_relative "../setup"

module Day4
  class Part2
    def initialize(input)
      @base_matrix = input.split("\n").map(&:strip).map { |line| line.split("") }
    end

    def solve
      small_matrices(@base_matrix).count do |sm_matrix|
        is_x_mas?(sm_matrix)
      end
    end

    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    private

    def small_matrices(matrix)
      indexes = (0..matrix.first.length - 1).to_a

      matrix.each_cons(3).flat_map do |lines|
        indexes.each_cons(3).map do |start, _, stop|
          lines.map { |line| line[start..stop] }
        end
      end
    end

    def is_x_mas?(matrix)
      %w[MAS SAM].include?(matrix[0][0] + matrix[1][1] + matrix[2][2]) &&
        %w[MAS SAM].include?(matrix[2][0] + matrix[1][1] + matrix[0][2])
    end
  end
end

puts Day4::Part2.from_input_file.solve
