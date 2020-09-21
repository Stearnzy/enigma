require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/enigma"

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new
    assert_instance_of Enigma, enigma
  end
end