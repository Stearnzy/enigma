require "minitest/autorun"
require "minitest/pride"
require "./lib/enigma"

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new
  end
end