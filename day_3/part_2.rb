require "bundler/setup"
require "debug"

def relevant_inputs(raw_input)
  raw_input.scan(/don't\(\)|do\(\)|mul\(\d+,\d+\)/)
end

def sum_inputs(standard_inputs)
  must_count = true

  standard_inputs.sum do |input|
    case input
    when "don't()"
      must_count = false
      0
    when "do()"
      must_count = true
      0
    else
      must_count ? input.scan(/\d+/).map(&:to_i).reduce(:*) : 0
    end
  end
end

raw_input = Pathname.new(__dir__).join("input.txt").read

raw_input
  .then { |_| relevant_inputs(_) }
  .then { |_| sum_inputs(_) }
  .then { |sum| puts sum }
