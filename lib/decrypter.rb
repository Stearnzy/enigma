require 'date'
require './lib/cryptograph'
require './lib/dateable'

class Decrypter < Cryptograph
  include Dateable

  # def random_number_generator
  #   rand.to_s[2..6]
  # end

  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end

  def key_generator(rand_num = random_number_generator)
    placements = [rand_num[0..1], rand_num[1..2], rand_num[2..3], rand_num[3..4]]
    placements.map! {|placement| placement.to_i}
    encryption_keys = Hash[@letter_keys.zip(placements)]
  end

  def match_letter_to_shifts(string)
    split_string(string).map do |set_of_four_chars|
      set_of_four_chars.zip(master_shift_count)
    end.flatten(1)
  end

  # def master_shift_count
  #   master = key_generator.merge(offset_generator) do |letter, key, offset|
  #     key + offset
  #   end
  # end

# Necessary method, used in both encrypt, decrypt
  def offset_generator
    last_four_date_squared = square_date[-4..-1]
    split_last_four = (last_four_date_squared.split(""))
    split_last_four.map! {|placement| placement.to_i}
    offset_values = Hash[@letter_keys.zip(split_last_four)]
  end
end