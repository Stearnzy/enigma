require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/decryptor"

class DecryptorTest < Minitest::Test
  def test_it_exists
    decryptor = Decryptor.new
    assert_instance_of Decryptor, decryptor
  end

  def test_readable_alphabet
    decryptor = Decryptor.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, decryptor.alphabet
  end
end