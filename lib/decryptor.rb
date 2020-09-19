require 'date'
require './lib/cryptograph'
require './lib/dateable'

class Decryptor < Cryptograph
  include Dateable

  def random_number_generator
    rand.to_s[2..6]
  end

  def split_string(string)
    string.downcase.split("").each_slice(4).to_a
  end
end