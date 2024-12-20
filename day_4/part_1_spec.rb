require_relative "../test_setup"
require_relative "part_1"

RSpec.describe Day4::Part1 do
  def do_action(input)
    described_class.new(input).solve
  end

  examples = <<-INPUT
    XMAS
    ....
    ....
    ....

    SAMX
    ....
    ....
    ....

    X...
    M...
    A...
    S...

    S...
    A...
    M...
    X...

    X...
    .M..
    ..A.
    ...S

    ...S
    ..A.
    .M..
    X...

    ...X
    ..M.
    .A..
    S...

    S...
    .A..
    ..M.
    ...X
  INPUT

  examples.split("\n\n").each do |input|
    it "solves basic matrices" do
      expect(do_action(input)).to eq 1
    end
  end
end
