require 'date'
require './lib/cryptograph'
require './lib/dateable'
require './lib/mappable'

class Enigma < Cryptograph
  include Dateable
  include Mappable

  def initialize
    
  end
end