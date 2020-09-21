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

  def offset_generator(date)
    last_four_date_squared = square_date(date)[-4..-1]
    split_last_four = (last_four_date_squared.split(""))
    split_last_four.map! {|placement| placement.to_i}
    @offset_shift = Hash[@letter_keys.zip(split_last_four)]
  end

  def generate_master_offset
    @master_shift = @key_shift.merge(@offset_shift) do |letter, key, off|
      key + off
    end
  end

  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end

  def match_letter_to_shifts(string)
    split_string(string).map do |set_of_four_chars|
      set_of_four_chars.zip(@master_shift)
    end.flatten(1)
  end
end