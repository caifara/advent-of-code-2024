require_relative "../setup"
require_relative "../shared/map"

class Garden < Map
  def regions
    [].tap do |regions|
      all_points = each_point_and_value.to_h

      until all_points.empty?
        point, value = all_points.shift

        region = Region.new(value)
        region.add_points point, *extract_other_points_for_region(region:, start: point, extract_from: all_points)

        regions << region
      end
    end
  end

  def extract_other_points_for_region(region:, start:, extract_from:)
    neighbors(start)
      .select { |point| extract_from.include?(point) && extract_from[point] == region.value }
      .tap { |points| points.each { |point| extract_from.delete(point) } }
      .flat_map { |point| [point, *extract_other_points_for_region(region:, start: point, extract_from: extract_from)] }
  end
end

class Region
  attr_reader :value

  def initialize(value)
    @value = value
    @perimeter = 0
    @points = []
  end

  def add_points(*points)
    @points.push(*points)
  end

  def perimeter
    @points.sum do |point|
      4 - neighbor_count(point)
    end
  end

  def neighbor_count(point)
    list = [point - Point[1, 0], point - Point[0, 1], point + Point[1, 0], point + Point[0, 1]]
    (list & @points).length
  end

  def surface
    @points.length
  end

  def price
    perimeter * surface
  end
end

module Day12
  class Part1 < Part
    def solve
      map = Garden.new(@input)
      map.regions.sum(&:price)
    end
  end
end

puts
puts Day12::Part1.from_input_file.solve
