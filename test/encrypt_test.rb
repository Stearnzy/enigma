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
    encrypt.stubs(:random_number_generator).returns("02385")
    assert_equal "02385", encrypt.random_number_generator
  end

  def test_key_generator
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02385")
    expected = {A: 2, B: 23, C: 38, D: 85}
    assert_equal expected, encrypt.key_generator
  end

  def test_square_date
    encrypt = Encrypt.new
    encrypt.stubs(:date_conversion).returns("091820")
    assert_equal "8430912400", encrypt.square_date
  end

  def test_offset_generator
    encrypt = Encrypt.new
    encrypt.stubs(:date_conversion).returns("091820")
    expected = {A: 2, B: 4, C: 0, D: 0}
    assert_equal expected, encrypt.offset_generator
  end

  def test_master_shift_count
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02385")
    encrypt.stubs(:date_conversion).returns("091820")
    expected = {A: 4, B: 27, C: 38, D:85}
    assert_equal expected, encrypt.master_shift_count
  end

  def test_split_string
    encrypt = Encrypt.new
    string = "Get Moving BROTHER"
    expected = [["g", "e", "t", " "], ["m", "o", "v", "i"], ["n", "g", " ", "b"],
                ["r", "o", "t", "h"], ["e", "r"]]
    assert_equal expected, encrypt.split_string(string)
  end

  def test_match_letter_to_shift
    encrypt = Encrypt.new
    string = "Move Along!!"
    encrypt.stubs(:random_number_generator).returns("02385")
    encrypt.stubs(:date_conversion).returns("091820")

    expected_1 = {A: 4, B: 27, C: 38, D:85}
    assert_equal expected_1, encrypt.master_shift_count

    expected_2 = [["m", [:A, 4]], ["o", [:B, 27]], ["v", [:C, 38]], ["e", [:D, 85]],
                [" ", [:A, 4]], ["a", [:B, 27]], ["l", [:C, 38]], ["o", [:D, 85]],
                ["n", [:A, 4]], ["g", [:B, 27]], ["!", [:C, 38]], ["!", [:D, 85]]]
    assert_equal expected_2, encrypt.match_letter_to_shifts(string)
  end

  def test_total_shifts_per_character
    skip
    encrypt = Encrypt.new
    string = "Move Along!!"

    encrypt.stubs(:random_number_generator).returns("02385")
    encrypt.stubs(:date_conversion).returns("091820")
    expected_1 = {A: 4, B: 27, C: 38, D:85}
    assert_equal expected_1, encrypt.master_shift_count

    require "pry"; binding.pry
  end

  def test_string_encryption
    skip
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02385")
    encrypt.stubs(:date_conversion).returns("091820")
    expected_1 = {A: 4, B: 27, C: 38, D:85}
    assert_equal expected_1, encrypt.master_shift_count

    assert_equal "lewps gsvlo", encrypt.encrypt("hello world")
    assert_equal "lenomnkgsowdhuoi!!!", encrypt.encrypt("Heckin Cool DUDE!!!")
  end
end