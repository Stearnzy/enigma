require 'date'
require './lib/cryptograph'
require './lib/dateable'

# May be able to remove require date..?
# Still need to give it output method, hash of encryption, key, date
class Encrypter < Cryptograph
  include Dateable

  def random_number_generator
    rand.to_s[2..6]
  end

  def key_generator(key = random_number_generator)
    placements = [key[0..1], key[1..2], key[2..3], key[3..4]]
    placements.map! {|placement| placement.to_i}
    encryption_keys = Hash[@letter_keys.zip(placements)]
  end

  def offset_generator
    last_four_date_squared = square_date[-4..-1]
    split_last_four = (last_four_date_squared.split(""))
    split_last_four.map! {|placement| placement.to_i}
    offset_values = Hash[@letter_keys.zip(split_last_four)]
  end

  def master_shift_count
    key_generator.merge(offset_generator) do |letter, key, offset|
      key + offset
    end
  end

# Used in both encrypt and decrypt
  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end

  def match_letter_to_shifts(string)
    split_string(string).map do |set_of_four_chars|
      set_of_four_chars.zip(master_shift_count)
    end.flatten(1)
  end

  def shifts_per_character(string)
    match_letter_to_shifts(string).map do |letter_shift|
      if @alphabet.include?(letter_shift[0])
        @alphabet.index(letter_shift[0]) + letter_shift[1][1]
      else
        letter_shift[0]
      end
    end
  end

# key_generator not called in below method... Likely need reworking
  def encrypt(string, key = random_number_generator, date = date_conversion)
    shifts_per_character(string).map do |index|
      if index.is_a?(String)
        index
      elsif index > 27
        @alphabet[index % 27]
      else
        @alphabet[index]
      end
    end.join
  end
end