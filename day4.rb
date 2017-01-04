# Day 4: Security Through Obscurity http://adventofcode.com/2016/day/4

# Just a namespace for `read` function.
module CodeReader

  # Not a strict pattern, but enough for the task
  PATTERN = /(?<encrypted_name>[a-z\-]+)\-(?<section_id>\d+)\[(?<checksum>[a-z]{5})\]/

  # Factory function. Expect a string with a code
  # Assumption: string must contain exactly one code
  def self.read(string)
    match = PATTERN.match(string)
    Code.new(match[:encrypted_name], match[:section_id], match[:checksum])
  end
end

# The class for represent a code. Encapsulates utility functions 
# to check if the code is real or not.
class Code
  attr_reader :sector_id

  def initialize(encrypted_name, sector_id, checksum)
    @encrypted_name = encrypted_name.to_s
    @sector_id = sector_id.to_i
    @checksum = checksum.to_s
  end

  def real?
    @encrypted_name.
      chars.
      select { |char| char != '-' }.
      group_by(&:itself).
      transform_values(&:count).
      sort do |(a, count_a), (b, count_b)|
        ((count_a == count_b) && (a < b) || (count_a > count_b)) ? -1 : 1
      end.
      map(&:first).
      take(5).join == @checksum
  end

  private

  def count(char)
    @encrypted_name.each_char.count { |name_char| name_char == char }
  end
end

require 'test/unit'
include Test::Unit::Assertions

# extracted examples from the task description
assert_equal(true, CodeReader.read("aaaaa-bbb-z-y-x-123[abxyz]").real?)
assert_equal(true, CodeReader.read("a-b-c-d-e-f-g-h-987[abcde]").real?)
assert_equal(true, CodeReader.read("not-a-real-room-404[oarel]").real?)
assert_equal(false, CodeReader.read("totally-real-room-200[decoy]").real?)

File.readlines("day4.input.txt").reduce(0) do |count, line|
  code = CodeReader.read(line)
  count += code.real? ? code.sector_id : 0
end.tap do |sum|
  puts "[Day 4][Task 1] Sum = #{sum}"
end

# Extend class with decode function. Very unsafe, but handy. That's ruby.
class Code
  def decode
    @encrypted_name.split('-').map do |name_part|
      chars = name_part.chars
      @sector_id.times { chars.map!(&:next) }
      chars.map! { |string| string.chars.last }.join
    end.join(' ')
  end
end

# extracted from the task description
assert_equal("very encrypted name", Code.new("qzmt-zixmtkozy-ivhz", 343, "").decode)

NORTHPOLE_RE = /.*north.*pole.*/
File.readlines("day4.input.txt").each do |line|
  code = CodeReader.read(line)
  print "Norhpole storage sector ID: ", code.sector_id, "\n" if code.real? && code.decode =~ NORTHPOLE_RE
end
