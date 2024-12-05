require_relative "../test_setup"
require_relative "part_2"

describe Day5::Part2 do
  def do_action(input)
    described_class.new(input).solve
  end

  it "does not count if page is in order" do
    input = <<-INPUT
    1|2

    1,2,3
    INPUT

    expect(do_action(input)).to eq(0)
  end

  it "counts if page not in order" do
    input = <<-INPUT
    2|1
    1|3

    1,2,3
    INPUT

    expect(do_action(input)).to eq(1) # correct order is 2, 1, 3
  end

  it "works on the given example" do
    input = <<-INPUT
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    INPUT

    expect(do_action(input)).to eq(123)
  end
end
