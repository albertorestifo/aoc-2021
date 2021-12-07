require "string_scanner"

class Day05 < Solver
  struct Point
    property x, y

    def initialize(@x : Int32, @y : Int32)
    end
  end

  def initialize(input : String)
    @movements = [] of Tuple(Point, Point)
    input.each_line do |line|
      s = StringScanner.new(line)

      a = scan_point(s)
      s.skip(/\s->\s/)
      b = scan_point(s)

      @movements.push({a, b})
    end
  end

  def part_1
    solve
  end

  def part_2
    solve
  end

  private def scan_point(s : StringScanner) : Point
    x = s.scan(/\d+/).not_nil!.to_i32
    s.skip(/,/)
    y = s.scan(/\d+/).not_nil!.to_i32

    Point.new(x, y)
  end

  private def update_visited(visited : Hash(Point, Int32), point : Point)
    if visited[point]?
      visited[point] += 1
    else
      visited[point] = 1
    end
  end

  def solve
    visited = Hash(Point, Int32).new
    @movements.each do |(from, to)|
      # Skip the points where we're not moving straight
      # Uncomment for Part 1 solution
      # if from.x != to.x && from.y != to.y
      #   next
      # end

      # Also consider diagonal movements
      # Comment out for Part 1 solution
      if from.x != to.x && from.y != to.y
        # 45 deg, meaning that we're good with just one point
        diff = (to.x - from.x).abs

        add_x = from.x < to.x
        add_y = from.y < to.y

        prev = from
        update_visited(visited, from)

        (1..diff).each do
          next_x = add_x ? prev.x += 1 : prev.x -= 1
          next_y = add_y ? prev.y += 1 : prev.y -= 1
          update_visited(visited, Point.new(next_x, next_y))
        end

        next
      end

      if from.x != to.x
        from_x = from.x
        to_x = to.x

        if from_x > to_x
          from_x, to_x = to_x, from_x
        end

        (from_x..to_x).each { |x| update_visited(visited, Point.new(x, from.y)) }
      end

      if from.y != to.y
        from_y = from.y
        to_y = to.y

        if from_y > to_y
          from_y, to_y = to_y, from_y
        end

        # Move horizontally
        (from_y..to_y).each { |y| update_visited(visited, Point.new(from.x, y)) }
      end
    end

    more_than_once = 0
    visited.each_value do |value|
      if value > 1
        more_than_once += 1
      end
    end

    puts more_than_once
  end
end
