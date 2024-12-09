require_relative "../test_setup"
require_relative "parts"

describe Day9::Part1 do
  describe "file_id" do
    def do_action(input)
      described_class.serialize(described_class.new(input).file_id)
    end

    disk_map_and_file_ids = {
      "12345" => "0..111....22222",
      "2333133121414131402" => "00...111...2...333.44.5555.6666.777.888899",
    }

    disk_map_and_file_ids.each do |disk_map, file_id|
      it "parses #{disk_map} to #{file_id}" do
        expect(do_action(disk_map)).to eq(file_id)
      end
    end
  end

  describe "compact" do
    def do_action(input)
      described_class.serialize(
        described_class.new(input).compact
      )
    end

    disk_map_and_compacted_file_ids = {
      "123" => "0111..", # 0..111
      "121" => "01..", # 0..1
      "12345" => "022111222......",
      "2333133121414131402" => "0099811188827773336446555566..............",
    }

    disk_map_and_compacted_file_ids.each do |disk_map, compacted_file_id|
      it "parses #{disk_map} to #{compacted_file_id}" do
        expect(do_action(disk_map)).to eq(compacted_file_id)
      end
    end
  end

  describe "checksum" do
    def do_action(input)
      described_class.checksum(described_class.new(input).compact)
    end

    disk_maps_and_checksums = {
      "2333133121414131402" => 1928,
    }

    disk_maps_and_checksums.each do |disk_map, checksum|
      it "parses #{disk_map} to #{checksum}" do
        expect(do_action(disk_map)).to eq(checksum)
      end
    end
  end
end

describe Day9::Part2 do
  describe "compact" do
    def do_action(input)
      described_class.serialize(
        described_class.new(input).compact
      )
    end

    disk_map_and_compacted_file_ids = {
      "123" => "0..111", # 0..11
      "121" => "01..", # 0..1
      "12121" => "021....",
      "12345" => "0..111....22222",
      "15345" => "022222111.........", # 0.....111....22222
      "2333133121414131402" => "00992111777.44.333....5555.6666.....8888..",
    }

    disk_map_and_compacted_file_ids.each do |disk_map, compacted_file_id|
      it "parses #{disk_map} to #{compacted_file_id}" do
        # pp described_class.serialize(described_class.new(disk_map).file_id)
        # pp described_class.new(disk_map).compact
        expect(do_action(disk_map)).to eq(compacted_file_id)
      end
    end
  end

  describe "checksum" do
    def do_action(input)
      described_class.checksum(described_class.new(input).compact_entries)
    end

    it "calculates the checksum" do
      expect(do_action("2333133121414131402")).to eq(2858)
    end
  end
end
