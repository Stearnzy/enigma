require "minitest/autorun"
require "minitest/pride"
require "./lib/cryptograph"

class CryptographTest < Minitest::Test
  def test_it_exists
    cryptograph = Cryptograph.new
    assert_instance_of Cryptograph, cryptograph
  end

  def test_readable_alphabet
    cryptograph = Cryptograph.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, cryptograph.alphabet
  end

  def test_all_shift_guides_start_nil
    cryptograph = Cryptograph.new
    assert_nil cryptograph.master_shift
    assert_nil cryptograph.key_shift
    assert_nil cryptograph.offset_shift
  end
end