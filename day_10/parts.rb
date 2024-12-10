require_relative "../setup"
require_relative "../shared/map"

class TopoMap < Map
  def find_trailheads
    each_point_and_value
      .select { |point, value| value == "0" }
      .map { |point, _| point }
  end

  def find_ways_up(from_point)
    current_height = value_at(from_point).to_i

    return from_point if current_height == 9

    neighbors(from_point)
      .select { |point| value_at(point).to_i == current_height + 1 }
      .map { |point| find_ways_up(point) }
      .flatten
  end

  def accessable_high_points_from(from_point)
    find_ways_up(from_point).uniq
  end
end

module Day10
  class Part1 < Part
    def solve
      map = TopoMap.new(@input)
      map.find_trailheads.sum do |trailhead|
        map.accessable_high_points_from(trailhead).length
      end
    end
  end

  class Part2 < Part
    def solve
      map = TopoMap.new(@input)
      map.find_trailheads.sum do |trailhead|
        map.find_ways_up(trailhead).length
      end
    end
  end
end

puts
puts Day10::Part2.from_input_file.solve
