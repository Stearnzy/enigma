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

  def test_key_generator
    enigma = Enigma.new
    enigma.stubs(:random_number_generator).returns("02715")

    expected_1 = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected_1, enigma.key_generator
    assert_equal expected_1, enigma.key_shift

    expected_2 = {A: 6, B: 65, C: 59, D: 98}
    assert_equal expected_2, enigma.key_generator("06598")
    assert_equal expected_2, enigma.key_shift
  end

  def test_square_date
    enigma = Enigma.new
    assert_equal "1672401025", enigma.square_date("040895")

    assert_equal "8449286400", enigma.square_date("091920")
  end

  def test_offset_generator
    enigma = Enigma.new
    date = "040895"

    enigma.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), enigma.offset_shift

    date = "091920"
    enigma.offset_generator(date)
    assert_equal ({A: 6, B: 4, C: 0, D: 0}), enigma.offset_shift
  end

  def test_generate_master_offset
    enigma = Enigma.new
    enigma.stubs(:random_number_generator).returns("02715")
    date = "040895"

    enigma.key_generator
    assert_equal ({A: 2, B: 27, C: 71, D: 15}), enigma.key_shift

    enigma.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), enigma.offset_shift

    enigma.generate_master_offset

    assert_equal ({A: 3, B: 27, C: 73, D: 20}), enigma.master_shift
  end

  def test_split_string
    enigma = Enigma.new
    string_1 = "HeLlO wOrLd"
    expected_1 = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected_1, enigma.split_string(string_1)

    string_2 = "keder ohulw"
    expected_2 = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected_2, enigma.split_string(string_2)
  end

  def test_match_letter_to_shift
    enigma = Enigma.new
    string = "Hello World!!"

    enigma.stubs(:random_number_generator).returns("02715")
    enigma.key_generator

    date = "040895"
    enigma.offset_generator(date)

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    actual_1 = enigma.generate_master_offset
    assert_equal expected_1, actual_1

    expected_2 = [["h", [:A, 3]], ["e", [:B, 27]], ["l", [:C, 73]], ["l", [:D, 20]],
                ["o", [:A, 3]], [" ", [:B, 27]], ["w", [:C, 73]], ["o", [:D, 20]],
                ["r", [:A, 3]], ["l", [:B, 27]], ["d", [:C, 73]], ["!", [:D, 20]],
                ["!", [:A, 3]]]
    assert_equal expected_2, enigma.match_letter_to_shifts(string)
  end

  # --- Encryption Tests ----

  def test_encrypt_total_shifts_per_character
    enigma = Enigma.new
    string = "Hello World!!"

    enigma.stubs(:random_number_generator).returns("02715")
    enigma.key_generator

    date = "040895"
    enigma.offset_generator(date)

    enigma.generate_master_offset

    expected = [10, 31, 84, 31, 17, 53, 95, 34, 20, 38, 76, "!", "!"]
    assert_equal expected, enigma.encrypt_index_shifts_per_character(string)
  end

  def test_encrypt_index_mapping
    enigma = Enigma.new
    string = "Hello World!!"

    enigma.stubs(:random_number_generator).returns("02715")
    enigma.key_generator

    date = "040895"
    enigma.offset_generator(date)

    enigma.generate_master_offset

    guide = enigma.encrypt_index_shifts_per_character(string)

    assert_equal "keder ohulw!!", enigma.index_mapping(guide)
  end
end
