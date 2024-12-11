require_relative "../test_setup"
require_relative "./parts"

describe Day10::Part1 do
  def do_action(input)
    described_class.new(input).solve
  end

  maps_w_scores = [
    [
      <<~MAP,
        0123
        1234
        8765
        9876
      MAP
      1,
    ],
    [
      <<~MAP,
        ...0...
        ...1...
        ...2...
        6543456
        7.....7
        8.....8
        9.....9
      MAP
      2,
    ],
    [
      <<~MAP,
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
      MAP
      36,
    ],
  ]

  maps_w_scores.each_with_index do |(map, score), i|
    it "handles #{map}" do
      expect(do_action(map)).to eq(score)
    end
  end
end
