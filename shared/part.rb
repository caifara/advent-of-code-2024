class Part
  def self.day
    name.split("::").first.match(/\d+/)[0]
  end

  def self.dir
    Pathname.new(__dir__).join("../day_#{day}")
  end

  def self.from_input_file = new dir.join("input.txt").read

  def self.from_test_input_file = new dir.join("test_input.txt").read

  def initialize(input)
    @input = input
  end
end
