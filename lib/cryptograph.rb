require './lib/dateable'

class Cryptograph
  include Dateable

  attr_reader :alphabet, :master_shift, :key_shift, :offset_shift

  def initialize
    @letter_keys = [:A, :B, :C, :D]
    @alphabet = ("a".."z").to_a << ' '
    @master_shift = nil
    @key_shift = nil
    @offset_shift = nil
  end

  def random_number_generator
    rand.to_s[2..6]
  end

  def key_generator(key = random_number_generator)
    placements = [key[0..1], key[1..2], key[2..3], key[3..4]]
    placements.map! {|placement| placement.to_i}
    @key_shift = Hash[@letter_keys.zip(placements)]
  end

end