require_relative "../setup"

module Day5
  class Part1
    def initialize(input)
      rules, updates = input
        .split("\n\n")
        .map { |block| block.split("\n").map(&:strip) }
      @rules = rules.map { |rule| rule.scan(/\d+/).map(&:to_i) }
      @updates = updates.map { |l| l.split(",").map(&:to_i) }
    end

    def solve
      @updates.keep_if { |update| @rules.all? { |first, last| order_respected?(update, first, last) } }
              .sum { |update| update[(update.length - 1) / 2] }
    end

    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    private

    def order_respected?(update, first, last)
      first_i = update.index(first)
      last_i = update.index(last)

      return true unless first_i && last_i

      first_i < last_i
    end
  end
end

# puts Day5::Part1.from_input_file.solve
