require_relative "../test_setup"
require_relative "./parts"

describe Day16::Part1 do
  mazes_and_scores = [
    [
      <<~MAZE,
        ####
        #SE#
        ####
      MAZE
      1,
    ],
    [
      <<~MAZE,
        #####
        #S.E#
        #####
      MAZE
      2,
    ],
    [
      <<~MAZE,
        ###
        #E#
        #S#
        ###
      MAZE
      1001,
    ],
    [
      <<~MAZE,
        ####
        #.E#
        #S.#
        ####
      MAZE
      1002,
    ],
    [
      <<~MAZE,
        #######
        #..#E.#
        #..##.#
        #S....#
        #######
      MAZE
      2007,
    ],
    [
      <<~MAZE,
        #######
        #..E..#
        #..##.#
        #S....#
        #######
      MAZE
      2004,
    ],
  ]

  mazes_and_scores.each_with_index do |(maze, espected_score), i|
    next unless i == 5

    it "handles #{maze} correctly" do
      path, score = described_class.new(maze).solve
      puts path.map(&:to_s).join(" -> ")
      expect(score).to eq(espected_score)
    end
  end
end

# describe Day16::Part2 do
#   def do_action(maze)
#     described_class.new(input).solve
#   end
# end
