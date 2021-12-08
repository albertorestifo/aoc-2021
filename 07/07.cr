class Day07 < Solver
  @crabs : Crabs

  def initialize(input : String)
    @crabs = Crabs.new(input.split(",").map(&.to_i64))
  end

  def part_1
    @crabs.cost
  end

  def part_2
    raise "Not implemented"
  end

  class Crabs
    @positions : Array(Int64)

    def initialize(positions : Array(Int64))
      @positions = positions.sort
    end

    private def mean
      middle = @positions.size / 2
      if @positions.size % 2 == 0
        return @positions[middle.to_i]
      end

      low = @positions[middle.floor.to_i]
      high = @positions[middle.ceil.to_i]

      (low + high) / 2
    end

    def cost
      m = mean
      @positions.reduce(0) do |acc, pos|
        acc + (pos - m).abs
      end
    end
  end
end
