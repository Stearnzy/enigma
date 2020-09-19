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

  def test_random_number_generator
    decryptor = Decryptor.new
    decryptor.stubs(:random_number_generator).returns("02715")
    assert_equal "02715", decryptor.random_number_generator
  end

  def test_random_number_always_returns_5_digits
    decryptor = Decryptor.new
    pass = 0
    fail = 0
    2000.times do
      s = decryptor.random_number_generator
      if s.length == 5
        pass += 1
      else
        fail += 1
      end
    end

    assert_equal 0, fail
    assert_equal 2000, pass
  end

  def test_split_string
    decryptor = Decryptor.new
    expected = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected, decryptor.split_string("keder ohulw")
  end
end