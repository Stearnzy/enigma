require 'date'
require './lib/cryptograph'
require './lib/dateable'

class Decrypter < Cryptograph
  include Dateable

  # def random_number_generator
  #   rand.to_s[2..6]
  # end

# Used in both encrypt, decrypt
  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end

# Used in both encrypt decrypt
  def master_shift_count(keyset, offset)
    @master_key_shift = keyset.merge(offset) do |letter, k, o|
      k + o
    end
  end

# Used in both encrypt and decrypt
  def key_set_generator(key = random_number_generator)
    placements = [key[0..1], key[1..2], key[2..3], key[3..4]]
    placements.map! {|placement| placement.to_i}
    encryption_keys = Hash[@letter_keys.zip(placements)]
  end

  def match_letter_to_shifts(string)
    split_string(string).map do |set_of_four_chars|
      set_of_four_chars.zip(@master_key_shift)
    end.flatten(1)
  end

# Necessary method, used in both encrypt, decrypt
# THIS HAS BEEN ALTERED
  def offset_generator(date)
    last_four_date_squared = square_date(date)[-4..-1]
    split_last_four = (last_four_date_squared.split(""))
    split_last_four.map! {|placement| placement.to_i}
    offset_values = Hash[@letter_keys.zip(split_last_four)]
  end

# This method is what needs to change from + to -
  def index_shifts_per_character(string)
    match_letter_to_shifts(string).map do |letter_shift|
      if @alphabet.include?(letter_shift[0])
        @alphabet.index(letter_shift[0]) - letter_shift[1][1]
      else
        letter_shift[0]
      end
    end
  end


# Args setup correctly, I think!
# Key MUST be called for the DECRYPT method?
  def decrypt(string, key, date = date_conversion)
    encryption_keys = key_set_generator(key)
    offset_keys = offset_generator(date)
    master_shift_count(encryption_keys, offset_keys)
    match_letter_to_shifts(string)
    index_shifts_per_character(string).map do |index|
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