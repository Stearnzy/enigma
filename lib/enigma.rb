require 'date'
require './lib/cryptograph'
require './lib/dateable'
require './lib/mappable'

class Enigma < Cryptograph
  include Dateable
  include Mappable

  def initialize
  end

  def encrypt(string, key = random_number_generator, date = date_conversion)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = encrypt_index_shifts_per_character(string)
    index_mapping(guide)
  end

  def decrypt(string, key, date)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = decrypt_index_shifts_per_character(string)
    index_mapping(guide)
  end
end