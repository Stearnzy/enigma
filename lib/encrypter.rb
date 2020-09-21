require 'date'
require './lib/cryptograph'
require './lib/dateable'
require './lib/mappable'

# May be able to remove require date..?
# Still need to give it output method, hash of encryption, key, date

class Encrypter < Cryptograph
  include Dateable
  include Mappable

  def encrypt_index_shifts_per_character(string)
    match_letter_to_shifts(string).map do |letter_shift|
      if @alphabet.include?(letter_shift[0])
        @alphabet.index(letter_shift[0]) + letter_shift[1][1]
      else
        letter_shift[0]
      end
    end
  end

  def encrypt(string, key = random_number_generator, date = date_conversion)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = encrypt_index_shifts_per_character(string)
    index_mapping(guide)
  end
end