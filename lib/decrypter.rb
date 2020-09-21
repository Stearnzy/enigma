require 'date'
require './lib/cryptograph'
require './lib/dateable'
require './lib/mappable'

class Decrypter < Cryptograph
  include Dateable
  include Mappable

  def index_shifts_per_character(string)
    match_letter_to_shifts(string).map do |letter_shift|
      if @alphabet.include?(letter_shift[0])
        @alphabet.index(letter_shift[0]) - letter_shift[1][1]
      else
        letter_shift[0]
      end
    end
  end

  def decrypt(string, key, date)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = index_shifts_per_character(string)
    index_mapping(guide)
  end
end