require_relative "../setup"

module Day19
  class Part1 < Part
    def initialize(input)
      towels, patterns = input.split("\n\n").map(&:strip)

      @towels = towels.split(",").map(&:strip)
      @patterns = patterns.split("\n").map(&:strip)
    end

    def solve
      @patterns.count do |pattern|
        creatable?(pattern)
      end
    end

    private

    def creatable?(pattern)
      @towels.any? do |towel|
        towel == pattern ? true : (pattern.start_with?(towel) && creatable?(pattern[towel.length..]))
      end
    end
  end

  class Part2 < Part
    def solve
    end
  end
end

# puts Day19::Part1.from_test_input_file.solve
puts Day19::Part1.from_input_file.solve
# puts Day19::Part2.from_test_input_file.solve
# puts Day19::Part2.from_input_file.solve
