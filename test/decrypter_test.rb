require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/decrypter"

class DecrypterTest < Minitest::Test
  def test_it_exists
    decrypter = Decrypter.new
    assert_instance_of Decrypter, decrypter
  end

  def test_readable_alphabet
    decrypter = Decrypter.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, decrypter.alphabet
  end

  def test_shift_values_start_at_nil
    decrypter = Decrypter.new
    assert_nil decrypter.master_shift
    assert_nil decrypter.key_shift
    assert_nil decrypter.offset_shift
  end

  def test_key_generator
    decrypter = Decrypter.new
    key = ("02715")

    expected_1 = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected_1, decrypter.key_generator

    expected_2 = {A: 6, B: 65, C: 59, D: 98}
    assert_equal expected_2, decrypter.key_generator("06598")
  end

  def test_square_date
    decrypter = Decrypter.new
    assert_equal "1672401025", decrypter.square_date("040895")

    assert_equal "8449286400", decrypter.square_date("091920")
  end

  def test_generate_master_offset
    decrypter = Decrypter.new
    key = "02715"
    date = "040895"

    decrypter.key_generator
    assert_equal ({A: 2, B: 27, C: 71, D: 15}), decrypter.key_shift

    decrypter.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), decrypter.offset_shift

    expected = {A: 3, B: 27, C: 73, D:20}
    actual = decrypter.generate_master_offset

    assert_equal expected, actual
  end

  def test_split_string
    decrypter = Decrypter.new
    message = "keder ohulw"

    expected = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected, decrypter.split_string(string)
  end

  def test_match_letter_to_shift
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    decrypter.key_generator(key)
    decrypter.offset_generator(date)
    assert_equal ({A: 3, B: 27, C: 73, D:20}), decrypter.generate_master_offset

    expected = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    actual = decrypter.match_letter_to_shifts(message)
    assert_equal expected, actual
  end

  def test_total_shifts_per_character
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    decrypter.key_generator(key)
    decrypter.offset_generator(date)
    assert_equal ({A: 3, B: 27, C: 73, D:20}), decrypter.generate_master_offset

    expected_1 = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    actual_1 = decrypter.match_letter_to_shifts(message)

    assert_equal expected_1, actual_1

# Be cautious, this is the result needed
    expected_2 = [7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3]
    assert_equal expected_2, decrypter.index_shifts_per_character(message)
  end

# Index shifts needs to change to pass. ^^
  def test_decrypt
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    require "pry"; binding.pry

    assert_equal "hello world", decrypter.decrypt(message, key, date)
  end
end