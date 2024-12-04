require_relative "../test_setup"
require_relative "part_2"

RSpec.describe Day4::Part2 do
  def do_action(input)
    described_class.new(input).solve
  end

  it "solves a basic matrix" do
    input = <<-INPUT
    M.S
    .A.
    M.S
    INPUT

    expect(do_action(input)).to eq 1
  end

  it "solves a basic matrix 2" do
    input = <<-INPUT
    S.S
    .A.
    M.M
    INPUT

    expect(do_action(input)).to eq 1
  end

  it "allows empty space" do
    input = <<-INPUT
    S.S.
    .A..
    M.M.
    INPUT

    expect(do_action(input)).to eq 1
  end

  it "allows empty space before" do
    input = <<-INPUT
    .S.S
    ..A.
    .M.M
    INPUT

    expect(do_action(input)).to eq 1
  end

  it "takes a second set horizontally into account" do
    input = <<-INPUT
    MSMS
    .AA.
    SMSM
    INPUT

    expect(do_action(input)).to eq 2
  end

  it "takes a second set vertically into account" do
    input = <<-INPUT
    S.S
    MAM
    MAM
    S.S
    INPUT

    expect(do_action(input)).to eq 2
  end

  it "solves the given example" do
    input = <<-INPUT
    .M.S......
    ..A..MSMS.
    .M.S.MAA..
    ..A.ASMSM.
    .M.S.M....
    ..........
    S.S.S.S.S.
    .A.A.A.A..
    M.M.M.M.M.
    ..........
    INPUT

    expect(do_action(input)).to eq 9
  end
end
