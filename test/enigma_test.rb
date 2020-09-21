require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/enigma"

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new
    assert_instance_of Enigma, enigma
  end

  def test_readable_alphabet
    enigma = Enigma.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, enigma.alphabet
  end

  def test_shift_values_start_at_nil
    enigma = Enigma.new
    assert_nil enigma.master_shift
    assert_nil enigma.key_shift
    assert_nil enigma.offset_shift
  end

  def test_random_number_generator
    enigma = Enigma.new
    enigma.stubs(:random_number_generator).returns("02715")
    assert_equal "02715", enigma.random_number_generator
  end

  def test_random_number_always_returns_5_digits
    engima = Enigma.new
    pass = 0
    fail = 0
    2000.times do
      s = engima.random_number_generator
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
