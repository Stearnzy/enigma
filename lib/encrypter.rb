require 'date'
require './lib/cryptograph'
require './lib/dateable'

# May be able to remove require date..?
# Still need to give it output method, hash of encryption, key, date
class Encrypter < Cryptograph
  include Dateable

# WARNING : INSERTING IN BOTH
  def random_number_generator
    rand.to_s[2..6]
  end

# BOTH
  def key_generator(key = random_number_generator)
    placements = [key[0..1], key[1..2], key[2..3], key[3..4]]
    placements.map! {|placement| placement.to_i}
    @key_shift = Hash[@letter_keys.zip(placements)]
  end

# BOTH
  def offset_generator(date)
    last_four_date_squared = square_date(date)[-4..-1]
    split_last_four = (last_four_date_squared.split(""))
    split_last_four.map! {|placement| placement.to_i}
    @offset_shift = Hash[@letter_keys.zip(split_last_four)]
  end

# BOTH
  def generate_master_offset
    @master_shift = @key_shift.merge(@offset_shift) do |letter, key, off|
      key + off
    end
  end

# BOTH
  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end

# BOTH
  def match_letter_to_shifts(string)
    split_string(string).map do |set_of_four_chars|
      set_of_four_chars.zip(@master_shift)
    end.flatten(1)
  end

# DIFFERENT
  def index_shifts_per_character(string)
    match_letter_to_shifts(string).map do |letter_shift|
      if @alphabet.include?(letter_shift[0])
        @alphabet.index(letter_shift[0]) + letter_shift[1][1]
      else
        letter_shift[0]
      end
    end
  end

# BOTH
  def index_mapping(input)
    input.map do |index|
      if index.is_a?(String)
        index
      elsif index > 27 || index < -27
        @alphabet[index % 27]
      else
        @alphabet[index]
      end
    end.join
  end

  # ONLY difference is METHOD NAME
  def encrypt(string, key = random_number_generator, date = date_conversion)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = index_shifts_per_character(string)
    index_mapping(guide)
  end
end