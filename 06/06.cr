class Day06 < Solver
  def initialize(@input : String)
  end

  def part_1
    colony = Colony.new(@input)
    colony.simulate
  end

  def part_2
    colony = Colony.new(@input)
    colony.simulate(256)
  end

  class Colony
    @fish : Array(Int64)

    def initialize(input : String)
      @fish = input.split(',').map(&.to_i).reduce(Array(Int64).new(9) { 0_i64 }) do |acc, fish|
        acc[fish] += 1
        acc
      end
    end

    def simulate(days : Int32 = 80)
      days.times { simulate_day }
      @fish.sum
    end

    private def simulate_day
      new_fish = @fish.shift
      @fish.push(new_fish)
      @fish[6] = @fish[6] + new_fish
    end
  end
end
