require 'date'
require './lib/cryptograph'
require './lib/dateable'


# Still need to give it output method, hash of encryption, key, date
class Encrypt < Cryptograph
  include Dateable

  def random_number_generator
    rand.to_s[2..6]
  end

  def key_generator
    rand_num = random_number_generator
    placements = [rand_num[0..1], rand_num[1..2], rand_num[2..3], rand_num[3..4]]
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
    master = key_generator.merge(offset_generator) do |letter, key, offset|
      key + offset
    end
  end

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