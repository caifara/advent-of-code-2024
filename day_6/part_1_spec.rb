require_relative "../test_setup"
require_relative "part_1"

describe Day6::Part1 do
  def do_action(input)
    described_class.new(input).result_map
  end

  maps = [
    <<~MAP,
      >.

      **
    MAP
    <<~MAP,
      .>

      .*
    MAP
    <<~MAP,
      >.#

      **#
    MAP
    <<~MAP,
      >#
      ..

      *#
      *.
    MAP
    <<~MAP,
      >.#
      ...
      .#.

      **#
      **.
      .#.
    MAP
  ].each_with_index do |map, i|
    next unless i == 4

    input, output = map.split("\n\n").map { |block| block.split("\n").map(&:strip).join("\n") }
    it "works on #{input}" do
      expect(do_action(input)).to eq output
    end
  end

  it "runs the given example" do
    input = <<~INPUT.strip
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    INPUT

    output = <<~OUTPUT.strip
      ....#.....
      ....*****#
      ....*...*.
      ..#.*...*.
      ..*****#*.
      ..*.*.*.*.
      .#*******.
      .*******#.
      #*******..
      ......#*..
    OUTPUT

    expect(do_action(input)).to eq output
  end
end

# 4584
# 2310
# 1778
