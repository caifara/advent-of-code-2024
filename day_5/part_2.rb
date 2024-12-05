require_relative "../setup"
require "benchmark"

module Day5
  class Part2
    def initialize(input)
      rules, updates = input
        .split("\n\n")
        .map { |block| block.split("\n").map(&:strip) }
      @rules = rules.map { |rule| rule.scan(/\d+/).map(&:to_i) }
      @updates = updates.map { |l| l.split(",").map(&:to_i) }
    end

    def solve
      @updates
        .reject { |update| all_rules_respected?(update) }
        .each { |update| correct_order(update) }
        .sum { |update| update[(update.length - 1) / 2] }
    end

    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    private

    def all_rules_respected?(update) = @rules.all? { |first, last| order_respected?(update, first, last) }

    def order_respected?(update, first, last)
      first_i = update.index(first)
      last_i = update.index(last)

      return true unless first_i && last_i

      first_i < last_i
    end

    def correct_order(update, rules = @rules.select { |first, last| update.include?(first) && update.include?(last) })
      needs_iteration = false

      rules.each do |first, last|
        first_i = update.index(first)
        last_i = update.index(last)

        next if first_i < last_i

        needs_iteration = true
        update[first_i], update[last_i] = update[last_i], update[first_i]
      end

      correct_order(update, rules) if needs_iteration
    end
  end
end

time = Benchmark.measure do
  10.times do
    puts Day5::Part2.from_input_file.solve
  end
end
puts time.real
