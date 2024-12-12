require_relative "../test_setup"
require_relative "./parts"

describe Day12::Part1 do
  def do_action(input)
    described_class.new(input).solve
  end

  maps_w_price = [
    [
      <<~MAP,
        AAAA
        BBCD
        BBCC
        EEEC
      MAP
      140,
    ],
    [
      <<~MAP,
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
      MAP
      1930,
    ],
  ]

  maps_w_price.each_with_index do |(map, price), i|
    it "handles #{map}" do
      expect(do_action(map)).to eq(price)
    end
  end
end

describe Day12::Part2 do
  def do_action(input)
    described_class.new(input).solve
  end

  maps_w_price = [
    [
      <<~MAP,
        AAAA
        BBCD
        BBCC
        EEEC
      MAP
      80,
    ],
    [
      <<~MAP,
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE
      MAP
      236,
    ],
    [
      <<~MAP,
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
      MAP
      1206,
    ],
  ]

  maps_w_price.each_with_index do |(map, price), i|
    it "handles #{map}" do
      expect(do_action(map)).to eq(price)
    end
  end
end
