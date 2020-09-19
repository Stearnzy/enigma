require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/encrypt"

class EncryptTest < Minitest::Test
  def test_it_exists
    encrypt = Encrypt.new
    assert_instance_of Encrypt, encrypt
  end

  def test_readable_alphabet
    encrypt = Encrypt.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, encrypt.alphabet
  end

  def test_random_number_generator
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02715")
    assert_equal "02715", encrypt.random_number_generator
  end

  def test_random_number_always_returns_5_digits
    encrypt = Encrypt.new
    pass = 0
    fail = 0
    2000.times do
      s = encrypt.random_number_generator
      if s.length == 5
        pass += 1
      else
        fail += 1
      end
    end

    assert_equal 0, fail
    assert_equal 2000, pass
  end

  def test_key_generator
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02715")
    expected = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected, encrypt.key_generator
  end

  def test_square_date
    encrypt = Encrypt.new
    encrypt.stubs(:date_conversion).returns("040895")
    assert_equal "1672401025", encrypt.square_date
  end

  def test_offset_generator
    encrypt = Encrypt.new
    encrypt.stubs(:date_conversion).returns("040895")
    expected = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected, encrypt.offset_generator
  end

  def test_master_shift_count
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02715")
    encrypt.stubs(:date_conversion).returns("040895")
    expected = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected, encrypt.master_shift_count
  end

  def test_split_string
    encrypt = Encrypt.new
    string = "HeLlO wOrLd"
    expected = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected, encrypt.split_string(string)
  end

  def test_match_letter_to_shift
    encrypt = Encrypt.new
    string = "Hello World!!"
    encrypt.stubs(:random_number_generator).returns("02715")
    encrypt.stubs(:date_conversion).returns("040895")

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected_1, encrypt.master_shift_count

    expected_2 = [["h", [:A, 3]], ["e", [:B, 27]], ["l", [:C, 73]], ["l", [:D, 20]],
                ["o", [:A, 3]], [" ", [:B, 27]], ["w", [:C, 73]], ["o", [:D, 20]],
                ["r", [:A, 3]], ["l", [:B, 27]], ["d", [:C, 73]], ["!", [:D, 20]],
                ["!", [:A, 3]]]
    assert_equal expected_2, encrypt.match_letter_to_shifts(string)
  end

  def test_total_shifts_per_character
    encrypt = Encrypt.new
    string = "Hello World!!"

    encrypt.stubs(:random_number_generator).returns("02715")
    encrypt.stubs(:date_conversion).returns("040895")

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected_1, encrypt.master_shift_count

    expected_2 = [10, 31, 84, 31, 17, 53, 95, 34, 20, 38, 76, "!", "!"]
    assert_equal expected_2, encrypt.shifts_per_character(string)
  end

  def test_string_encryption
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02715")
    encrypt.stubs(:date_conversion).returns("040895")
    expected_1 = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected_1, encrypt.master_shift_count

    assert_equal "keder ohulw!!", encrypt.encrypt("Hello World!!")
    assert_equal "kevdlnswrodtguwy!!!", encrypt.encrypt("Heckin Cool DUDE!!!")
  end
end