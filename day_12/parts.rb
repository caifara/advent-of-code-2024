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

  def price
    perimeter * surface
  end

  def discounted_price
    sides * surface
  end

  private

  def perimeter
    @points.sum do |point|
      4 - neighbors_in_region(point).length
    end
  end

  def sides
    points_with_fences = @points
      .flat_map { |p| fence_sides(p).map { |fence_side| [p, fence_side] } }

    points_with_fences.group_by(&:last).sum do |fence_side, points_with_fences|
      points = points_with_fences.map(&:first)

      if fence_side == :left || fence_side == :right
        points.group_by(&:x).sum do |x, points|
          1 + points.map(&:y).sort.each_cons(2).map { |y1, y2| y2 - y1 }.reject { |diff| diff == 1 }.length
        end
      else
        points.group_by(&:y).sum do |y, points|
          1 + points.map(&:x).sort.each_cons(2).map { |x1, x2| x2 - x1 }.reject { |diff| diff == 1 }.length
        end
      end
    end
  end

  def surface
    @points.length
  end

  def neighbors_in_region(point)
    potential_neighbors = {
      (point - Point[1, 0]) => :left,
      (point - Point[0, 1]) => :down,
      (point + Point[1, 0]) => :right,
      (point + Point[0, 1]) => :up,
    }
    potential_neighbors.keep_if { |point, _| @points.include?(point) }
  end

  def fence_sides(point)
    %i[left down right up] - neighbors_in_region(point).values
  end
end

module Day12
  class Part1 < Part
    def solve
      map = Garden.new(@input)
      map.regions.sum(&:price)
    end
  end

  class Part2 < Part
    def solve
      map = Garden.new(@input)
      map.regions.sum(&:discounted_price)
    end
  end
end

puts
# puts Day12::Part1.from_input_file.solve
# puts Day12::Part2.from_input_file.solve
