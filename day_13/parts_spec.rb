require_relative "../test_setup"
require_relative "./parts"

describe Day13::Part1 do
  def do_action(input)
    described_class.new(input).solve
  end

  inputs_solutions = [
    [
      <<~MAP,
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
      MAP
      280,
    ],
    [
      <<~MAP,
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400

        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176

        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450

        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
      MAP
      480,
    ],
  ]

  inputs_solutions.each_with_index do |(input, solution), i|
    it "handles #{input}" do
      expect(do_action(input)).to eq(solution)
    end
  end
end

describe Day13::Part2 do
  def do_action(input)
    described_class.new(input).solve
  end

  inputs_solutions = [
    [
      <<~MAP,
        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176
      MAP
      459236326669,
    ],
    [
      <<~MAP,
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400

        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176

        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450

        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
      MAP
      875318608908,
    ],
  ]

  inputs_solutions.each_with_index do |(input, solution), i|
    it "handles #{input}" do
      expect(do_action(input)).to eq(solution)
    end
  end
end
