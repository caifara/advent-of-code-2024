require_relative "../test_setup"
require_relative "./parts"

describe Day17::Part1 do
  describe Instruction do
    def do_action(instr_input)
      instruction = Instruction.new(**instr_input.transform_keys(&:downcase))

      {
        output: instruction.execute,
        **instruction.registers.transform_keys(&:upcase),
      }.delete_if { |_, v| v.nil? }
    end

    instructions_and_output = [
      [{ C: 9, prg: [2, 6] }, { B: 1, C: 9, output: [] }],
      [{ A: 10, prg: [5, 0, 5, 1, 5, 4] }, { A: 10, output: [0, 1, 2] }],
      [{ B: 29, prg: [1, 7] }, { B: 26, output: [] }],
      [{ B: 2024, C: 43690, prg: [4, 0] }, { B: 44354, C: 43690, output: [] }],
      [{ A: 729, B: 0, C: 0, prg: [0, 1, 5, 4, 3, 0] }, { A: 0, B: 0, C: 0, output: [4, 6, 3, 5, 6, 3, 5, 2, 1, 0] }],
      [{ A: 2024, prg: [0, 1, 5, 4, 3, 0] }, { A: 0, output: [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0] }],
    ]

    instructions_and_output.each_with_index do |(instr_inputs, expected_output), i|
      # next unless i == 0

      it "handles #{instr_inputs} correctly" do
        expect(do_action(instr_inputs)).to eq(expected_output)
      end
    end
  end
end

describe Day17::Part2 do
  describe Instruction do
    def do_action(instr_input)
      instruction = Instruction.new(**instr_input.transform_keys(&:downcase))

      instruction.execute
    end

    instructions_and_output = [
      [{ A: 10, prg: [5, 4] }, [2]],
      [{ A: 100, prg: [2, 4, 1, 1, 7, 5, 4, 6, 0, 3, 1, 4, 5, 5, 3, 0] }, [2]],
    ]

    instructions_and_output.each_with_index do |(instr_inputs, expected_output), i|
      # next unless i == 0

      it "handles #{instr_inputs} correctly" do
        expect(do_action(instr_inputs)).to eq(expected_output)
      end
    end
  end
end
