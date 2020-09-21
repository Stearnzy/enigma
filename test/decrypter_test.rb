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

    expected = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected, decrypter.key_generator(key)
  end

  def test_square_date
    decrypter = Decrypter.new
    assert_equal "1672401025", decrypter.square_date("040895")

    assert_equal "8449286400", decrypter.square_date("091920")
  end

  def test_offset_generator
    decrypter = Decrypter.new
    date = "040895"

    decrypter.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), decrypter.offset_shift
  end

  def test_generate_master_offset
    decrypter = Decrypter.new
    key = "02715"
    date = "040895"

    decrypter.key_generator(key)
    assert_equal ({A: 2, B: 27, C: 71, D: 15}), decrypter.key_shift

    decrypter.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), decrypter.offset_shift

    decrypter.generate_master_offset

    assert_equal ({A: 3, B: 27, C: 73, D: 20}), decrypter.master_shift
  end

  def test_split_string
    decrypter = Decrypter.new
    message = "keder ohulw"

    expected = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected, decrypter.split_string(message)
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
    decrypter.generate_master_offset

    expected_1 = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    actual_1 = decrypter.match_letter_to_shifts(message)

    assert_equal expected_1, actual_1

    expected_2 = [7, -23, -70, -16, 14, -1, -59, -13, 17, -16, -51]
    assert_equal expected_2, decrypter.index_shifts_per_character(message)
  end

  def test_index_mapping
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    decrypter.key_generator(key)
    decrypter.offset_generator(date)
    decrypter.generate_master_offset

    guide = decrypter.index_shifts_per_character(message)

    assert_equal "hello world", decrypter.index_mapping(guide)
  end

  def test_decrypt
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    assert_equal "hello world", decrypter.decrypt(message, key, date)
  end
end