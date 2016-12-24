require 'test/unit'

# Day1 Task 1 http://adventofcode.com/2016/day/1
class TaxiCabNotationReader
  attr_reader :direction
  attr_reader :coords

  def initialize(coords)
    @initial_coords = coords
    @direction = [[0,1],[1,1],[0,-1],[1,-1]].cycle
    reset!()
  end

  def walk(steps)
    index, sign = direction.peek
    coords[index] += steps*sign
  end

  def R
    direction.next
  end

  # L == R, R, R
  def L
    3.times { R() }
  end

  def run!(str)
    str.split(',').map(&:strip).map { |code| [code[0], code[1..-1].to_i] }.each { |(command, steps)|
      self.send(command.to_sym)
      walk(steps)
      puts "Coords: " + coords.to_s
    }
  end

  # return L1 norm
  def distance
    coords.map(&:abs).reduce(&:+)
  end

  def reset!()
    @coords = @initial_coords.dup
  end
end

include Test::Unit::Assertions

reader = TaxiCabNotationReader.new([0,0])
reader.run!("R2, L3")
assert_equal(5, reader.distance)

reader.reset!
reader.run!("R2, R2, R2")
assert_equal(2, reader.distance)

reader.reset!
reader.run!("R5, L5, R5, R3")
assert_equal(12, reader.distance)

# Solution
puts "Puzzle 1"
reader.reset!
easter_bunny_hq_map = "R1, L3, R5, R5, R5, L4, R5, R1, R2, L1, L1, R5, R1, L3, L5, L2, R4, L1, R4, R5, L3, R5, L1, R3, L5, R1, L2, R1, L5, L1, R1, R4, R1, L1, L3, R3, R5, L3, R4, L4, R5, L5, L1, L2, R4, R3, R3, L185, R3, R4, L5, L4, R48, R1, R2, L1, R1, L4, L4, R77, R5, L2, R192, R2, R5, L4, L5, L3, R2, L4, R1, L5, R5, R4, R1, R2, L3, R4, R4, L2, L4, L3, R5, R4, L2, L1, L3, R1, R5, R5, R2, L5, L2, L3, L4, R2, R1, L4, L1, R1, R5, R3, R3, R4, L1, L4, R1, L2, R3, L3, L2, L1, L2, L2, L1, L2, R3, R1, L4, R1, L1, L4, R1, L2, L5, R3, L5, L2, L2, L3, R1, L4, R1, R1, R2, L1, L4, L4, R2, R2, R2, R2, R5, R1, L1, L4, L5, R2, R4, L3, L5, R2, R3, L4, L1, R2, R3, R5, L2, L3, R3, R1, R3"
reader.run!(easter_bunny_hq_map)
puts reader.distance


# To solve a second part of the puzzle the class can be extended to return location after each step. I decided just to return an enumerator and implement logic outside.
# Instead some linear geometry algorithms can be used here.
class TraceableTaxiCabNotationReader < TaxiCabNotationReader

  # feels hacky but it is adventure, isn't it?
  def run_with_trace!(str)
    Enumerator.new do |list|
      str.split(',').map(&:strip).map { |code| [code[0], code[1..-1].to_i] }.each do |(command, steps)|
        # Just turn
        run!("#{command}0")
        steps.times do
          walk(1)
          list.yield coords, distance
        end
      end
    end
  end
end

puts "Puzzle 2"
require 'set'
locations = Set.new
reader = TraceableTaxiCabNotationReader.new([0,0])
reader.run_with_trace!(easter_bunny_hq_map).find do |(location, distance)|
  if locations.include?(location)
    puts "Solution: #{distance} (#{location})"
    true
  else
    locations.add(location)
    puts "Location: #{location}"
    false
  end
end
