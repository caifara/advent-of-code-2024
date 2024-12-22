require_relative "map"

class Maze < Map
  attr_reader :runner

  def initialize(input)
    super

    transform_entries_and_values
  end

  def serialize(add_points: [], mark: "O")
    @entries.map.with_index do |row, y|
      row.map.with_index do |v, x|
        if add_points.include?(Point[x, y])
          mark
        else
          v.to_s
        end
      end.join
    end.join("\n")
  end

  private

  def transform_entries_and_values
    each_point_and_value do |point, v|
      value = case v
        when "." then EmptySpace.new
        when "#" then Wall.new
        when "E" then EndTile.new
        when "S" then Runner.new(map: self, point:)
        else raise "Unknown value: #{v}"
        end

      @runner = value if value.is_a?(Runner)

      set_value_at(point, value)
    end
  end
end
