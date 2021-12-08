require "option_parser"

require "./shared/*"
require "./**"

selected_day : String? = nil
test = false
part_2 = false

OptionParser.parse do |parser|
  parser.on("-d DAY", "--day=DAY", "Select day of puzzle to solve") { |day| selected_day = day }
  parser.on("-t", "--test", "Run with test dataset") { test = true }
  parser.on("-p2", "--part_two", "Run the part 2 solver") { part_2 = true }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option"
    STDERR.puts parser
    exit(1)
  end
end

unless selected_day
  STDERR.puts "ERROR: Missing required argument -d/--day"
  exit(1)
end

solvers = {
  "06" => Day06,
  "07" => Day07,
}

unless solvers[selected_day]?
  STDERR.puts "Solution not available for day #{selected_day}"
end

if test
  puts "WARN: Running against test dataset"
end

input = File.read("./#{selected_day}/#{test ? "test" : "input"}")
solver = solvers[selected_day].new(input)

if part_2
  puts "Solution to Part 2:"
  puts solver.part_2
else
  puts "Solution to Part 1:"
  puts solver.part_1
end
