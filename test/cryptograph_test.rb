require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
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

  def test_random_number_generator
    cryptograph = Cryptograph.new
    cryptograph.stubs(:random_number_generator).returns("02715")
    assert_equal "02715", cryptograph.random_number_generator
  end

  def test_random_number_always_returns_5_digits
    cryptograph = Cryptograph.new
    pass = 0
    fail = 0
    2000.times do
      s = cryptograph.random_number_generator
      if s.length == 5
        pass += 1
      else
        fail += 1
      end
    end

    assert_equal 0, fail
    assert_equal 2000, pass
  end
end