class BasicRunner
  attr_reader :paths, :shortest_path

  def initialize(map:, point:)
    @map = map
    @point = point

    @paths = []
    @shortest_path = nil

    @points_and_tails = {}
  end

  def run
    find_paths

    # puts @map.serialize(add_points: @shortest_path.map(&:point), mark: "O")

    @shortest_path
  end

  def to_s = "S"

  private

  def find_paths
    paths = [[RunnerPosition.new(point: @point, tail: [])]]

    puts @map.serialize

    until paths.empty?
      puts "paths: #{paths.length}"

      paths = paths
        .flat_map { |tail| next_positions(tail:) }
        .compact
    end
  end

  def next_positions(tail:)
    last_position = tail.last

    last_point = last_position.point

    @map.neighbors(last_point).map do |_dir, new_point|
      new_point_type = @map.value_at(new_point)

      next if new_point_type.is_a?(Runner)
      next if new_point_type.is_a?(Wall)

      case new_point_type
      when EndTile
        new_tail = (tail + [RunnerPosition.new(point: new_point, tail:)])

        tail_length = new_tail.length

        @paths << new_tail

        if @shortest_path.nil? || tail_length < @shortest_path.length
          @shortest_path = new_tail
        end

        nil
      when EmptySpace
        if tail.any? { |rp| rp.point == new_point }
          nil
        elsif @shortest_path && tail.length > @shortest_path.length
          nil
        else
          new_tail = tail + [RunnerPosition.new(point: new_point, tail:)]

          if new_tail.any? { |rp| (shortest_path = @points_and_tails[rp.point]) && shortest_path != rp.path }
            # pp new_tail.map { |rp| [rp.point, rp.cumulative_score, @points_and_tails[rp.point]] }
            # clear_and_show @map.serialize(add_points: new_tail.map(&:point), mark: "§")
            # puts "aborting #{new_tail.map(&:point)} got lower score"
            nil
          else
            @points_and_tails[new_point] = new_tail

            new_tail
          end
        end
      else raise "Unknown value: #{new_point}"
      end
    end
  end
end

class RunnerPosition
  attr_reader :point, :tail

  def initialize(point:, tail:)
    @point = point
    @tail = tail
  end

  def path
    @tail + [self]
  end

  def to_s = "#{@point}, #{@tail.length}"
end
