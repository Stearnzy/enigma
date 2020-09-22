require 'date'
require './lib/cryptograph'
require './lib/dateable'
require './lib/mappable'

class Enigma < Cryptograph
  include Dateable
  include Mappable

  def encrypt(string, key = random_number_generator, date = date_conversion)
    key_generator(key)
    offset_generator(date)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = encrypt_index_shifts_per_character(string)
    return {
            encryption: index_mapping(guide),
            key: key,
            date: date
          }
  end

  def decrypt(string, key, date = date_conversion)
    key_generator(key)
    offset_generator(date = date_conversion)
    generate_master_offset
    match_letter_to_shifts(string)
    guide = decrypt_index_shifts_per_character(string)
    index_mapping(guide)
    return {
            decryption: index_mapping(guide),
            key: key,
            date: date
          }
  end
end