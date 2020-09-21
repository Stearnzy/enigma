require 'date'
require './lib/cryptograph'
require './lib/dateable'

class Decrypter < Cryptograph
  include Dateable

# BOTH
  def key_generator(key)
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
    reduced_shifts = match_letter_to_shifts(string).each do |letter, shift|
      shift.map do |letter_key, shift_count|
        if shift_count > 27
          shift_count = shift_count % 27
        else
          shift_count
        end
      end
    end


    # reduced_shifts.map do |shift_count|
    #   strin
      # if @alphabet.include?(letter_shift[0])
      #   @alphabet.index(letter_shift[0]) - letter_shift[1][1]
      # else
      #   letter_shift[0]
      # end
    # end
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