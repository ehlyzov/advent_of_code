# Day 5: How About a Nice Game of Chess? http://adventofcode.com/2016/day/5

# The first task can be easy solved by explicit using of enumerators.
# Let's create an enumerator which represents an infinite passcode based on
# a room_id and take the first eight chars.

require 'digest'

def decode(room_id)
  md5 = Digest::MD5.new
  index = 0
  Enumerator.new do |enum|
    loop do
      hash = md5.hexdigest("#{room_id}#{index}")
      if hash.start_with?('00000')
        print "Scanned: #{index} Found: #{hash}\r"
        enum << hash[5]
      end
      index += 1
    end
  end
end

puts "Wait, hacking takes time..."
require 'test/unit'
include Test::Unit::Assertions
assert_equal("18f47a30", decode('abc').take(8).join(''))
puts "Tests are OK. Decoding the input..."

decode('ugkcyxxp').take(8).join('').tap do |answer|
  puts "[Day 5][Task 1] Answer: #{answer}"
end

# The second task is not very different from the first one, so let's modify
# our enumerator by adding some kind of memory.

puts "[Task 2]"

require 'set'
def decode_with_position(room_id)
  md5 = Digest::MD5.new
  index = 0
  used_indexes = Set.new
  Enumerator.new do |enum|
    loop do
      hash = md5.hexdigest("#{room_id}#{index}")
      position = hash[5]
      char = hash[6]
      if hash.start_with?('00000') && ('0'..'7').cover?(position) && !used_indexes.include?(position)
        used_indexes.add(position)
        print "\rScanned: #{index} Found: #{hash}"
        enum << [position, char]
      end
      index += 1
    end
  end
end

assert_equal("05ace8e3", decode_with_position('abc').take(8).sort.map(&:last).join(''))
puts "\nTests are OK. Decoding the input..."

puts "\nAnswer %s" % decode_with_position('ugkcyxxp').take(8).sort.map(&:last).join('')
