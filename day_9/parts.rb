require_relative "../setup"

module Day9
  class Entry
    attr_accessor :value

    def self.[](value)
      new(value)
    end

    def initialize(value)
      @value = value
    end

    def empty? = @value.nil?
    def present? = !empty?

    def to_s = @value.nil? ? "." : @value.to_s
  end

  class Part
    def self.from_input_file = new Pathname.new(__dir__).join("input.txt").read

    def self.from_test_input_file = new Pathname.new(__dir__).join("test_input.txt").read

    def self.checksum(compacted)
      compacted.each_with_index.sum do |entry, i|
        entry.empty? ? 0 : entry.value.to_i * i
      end
    end

    def self.serialize(to_serialize) # a compact or a file_id
      to_serialize.map(&:to_s).join.force_encoding("UTF-8")
    end

    def initialize(input)
      @input = input
    end
  end

  class Part1 < Part
    def file_id
      @file_id = @input.split("").each_slice(2).each_with_index.map do |(file_block, empty_space), i|
        [Entry[i]] * file_block.to_i + [Entry[nil]] * empty_space.to_i
      end.flatten
    end

    def compact
      data_to_rearrange = file_id.select(&:present?)

      @file_id.map do |entry|
        if entry.empty?
          data_to_rearrange.pop || Entry[nil]
        else
          data_to_rearrange.shift || Entry[nil]
        end
      end
    end
  end

  class Part2 < Part
    class DiskBlock
      attr_accessor :file_id, :size

      def initialize(file_id:, size:)
        @file_id = file_id
        @size = size
      end

      def <=(other) = @size <= other.size

      def empty? = @file_id.nil?

      def file? = !empty?

      def to_s = @file_id.nil? ? "." * @size : @file_id.to_s * @size

      def ==(other) = @file_id == other.file_id && @size == other.size

      def to_entries = [Entry[@file_id]] * @size
    end

    def file_id
      @file_id ||= @input.split("").each_slice(2).each_with_index.map do |(file_block, empty_space), i|
        [DiskBlock.new(file_id: i, size: file_block.to_i), DiskBlock.new(file_id: nil, size: empty_space.to_i)]
      end.flatten
    end

    def compact
      blocks_to_rearrange = file_id.select(&:file?)

      compacted = file_id.map(&:dup)

      compacted = compacted.map do |disk_entry|
        if disk_entry.file?
          blocks_to_rearrange.delete(disk_entry) || DiskBlock.new(file_id: nil, size: disk_entry.size)
        elsif disk_entry.empty?
          fit_and_delete_candidates_in(empty_block: disk_entry, candidate_blocks: blocks_to_rearrange)
        end
      end.flatten
    end

    def compact_entries
      compact.map(&:to_entries).flatten
    end

    private

    def fit_and_delete_candidates_in(empty_block:, candidate_blocks:)
      [].tap do |blocks_in_empty_block|
        loop do
          if fitting_block_index = candidate_blocks.reverse.find_index { |disk_block| disk_block <= empty_block }
            fitting_block = candidate_blocks.delete_at(candidate_blocks.length - 1 - fitting_block_index)

            blocks_in_empty_block << fitting_block

            empty_block = DiskBlock.new(file_id: nil, size: empty_block.size - fitting_block.size)
          else
            blocks_in_empty_block << empty_block
            break
          end
        end
      end
    end
  end
end

puts
# puts Day9::Part1.checksum(Day9::Part1.from_input_file.compact)
# 6200294120911
# puts Day9::Part.checksum(Day9::Part2.from_input_file.compact_entries)
# 6227018762750
