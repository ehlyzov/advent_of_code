require 'test/unit'
include Test::Unit::Assertions

module TripleReader
  DELIMITER = ' '

  def self.read(string)
    split(string).tap do |parts|
      raise unless parts.size == 3
    end
  end

  private

  def self.split(string)
    string.to_s.strip.split(DELIMITER).map(&:to_i)
  end
end

class Triple

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def possible?
    @a + @b > @c && @a + @c > @b && @b + @c > @a
  end

end

assert_equal(false, Triple.new(5, 10, 25).possible?)

count = File.readlines("day3_1.input.txt").reduce(0) do |count, line|
  count += Triple.new(*TripleReader.read(line)).possible? ? 1 : 0
end

puts "Solution Day 3 Task 1"
puts "Possible triangles: #{count}"

require 'matrix'

module VerticalTripleReader
  def self.read(lines)
    return [] unless lines.size == 3
    Matrix[ *lines.map { |line| TripleReader.read(line) } ].
      transpose.
      to_a.
      map { |parts| Triple.new(*parts) }
  end
end

count = File.readlines("day3_1.input.txt").each.
        with_index.slice_after { |_, index| index % 3 == 2 }. # group by 3

        # map(&:first) is needed because each line is a pair of a string and index
        map { |lines| VerticalTripleReader.read(lines.map(&:first)) }.
        map { |triples| triples.count { |triple| triple.possible? }}.
        sum

puts "Solution Day 3 Task 2"
puts "Possible triangles: #{count}"
