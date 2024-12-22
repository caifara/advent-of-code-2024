require_relative "../setup"

class Part
  def initialize(input)
    towels, patterns = input.split("\n\n").map(&:strip)

    @towels = towels.split(",").map(&:strip)
    @patterns = patterns.split("\n").map(&:strip)
  end
end

module Day19
  class Part1 < Part
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
      max_partial_length = @towels.map(&:length).max

      @patterns.sum do |pattern|
        partials = 0.upto(pattern.length - 1).map do |i|
          pattern[i, i + max_partial_length]
        end

        index_w_next_indices = partials.each_with_object({}).with_index do |(partial, result), i|
          matching_towels = @towels.select { |towel| partial.start_with?(towel) }

          result[i] = matching_towels.map { |towel| i + towel.length }
        end

        count_ways_with(index_w_next_indices)
      end
    end

    def count_ways_with(index_w_next_indices, from_index: 0, cache: {})
      return 1 if from_index == index_w_next_indices.length

      next_indices = index_w_next_indices[from_index]

      next_indices.sum do |next_index|
        cache[next_index] ||= count_ways_with(index_w_next_indices, from_index: next_index, cache:)
      end
    end
  end
end

# puts Day19::Part1.from_test_input_file.solve
# puts Day19::Part1.from_input_file.solve
# puts Day19::Part2.from_test_input_file.solve
puts Day19::Part2.from_input_file.solve
