module Mappable

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
  #
  # def encrypt_index_shifts_per_character(string)
  #   match_letter_to_shifts(string).map do |letter_shift|
  #     if @alphabet.include?(letter_shift[0])
  #       @alphabet.index(letter_shift[0]) + letter_shift[1][1]
  #     else
  #       letter_shift[0]
  #     end
  #   end
  # end
  #
  # def decrypt_index_shifts_per_character(string)
  #   match_letter_to_shifts(string).map do |letter_shift|
  #     if @alphabet.include?(letter_shift[0])
  #       @alphabet.index(letter_shift[0]) - letter_shift[1][1]
  #     else
  #       letter_shift[0]
  #     end
  #   end
  # end
  #
  # def encrypt(string, key = random_number_generator, date = date_conversion)
  #   key_generator(key)
  #   offset_generator(date)
  #   generate_master_offset
  #   match_letter_to_shifts(string)
  #   guide = encrypt_index_shifts_per_character(string)
  #   index_mapping(guide)
  # end
  #
  # def decrypt(string, key, date)
  #   key_generator(key)
  #   offset_generator(date)
  #   generate_master_offset
  #   match_letter_to_shifts(string)
  #   guide = decrypt_index_shifts_per_character(string)
  #   index_mapping(guide)
  # end
end