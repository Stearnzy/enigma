require "./test/test_helper"

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

  def test_readable_key_letters
    cryptograph = Cryptograph.new
    assert_equal [:A, :B, :C, :D], cryptograph.letter_keys
  end

  def test_all_shift_guides_start_nil
    cryptograph = Cryptograph.new
    assert_nil cryptograph.master_shift
    assert_nil cryptograph.key_shift
    assert_nil cryptograph.offset_shift
  end

  def test_random_number_generator
    cryptograph = Cryptograph.new
    assert_instance_of String, cryptograph.random_number_generator
    assert_equal 5, cryptograph.random_number_generator.length
  end

  def test_key_generator
    cryptograph = Cryptograph.new
    cryptograph.stubs(:random_number_generator).returns("02715")

    expected_1 = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected_1, cryptograph.key_generator
    assert_equal expected_1, cryptograph.key_shift

    expected_2 = {A: 6, B: 65, C: 59, D: 98}
    assert_equal expected_2, cryptograph.key_generator("06598")
    assert_equal expected_2, cryptograph.key_shift
  end

  def test_date_conversion_returns_six_digit_string
    cryptograph = Cryptograph.new

    assert_instance_of String, cryptograph.date_conversion
    assert_equal 6, cryptograph.date_conversion.length
  end


  def test_square_date
    cryptograph = Cryptograph.new
    assert_equal "1672401025", cryptograph.square_date("040895")

    assert_equal "8449286400", cryptograph.square_date("091920")
  end

  def test_offset_generator
    cryptograph = Cryptograph.new
    date_1 = "040895"
    expected_1 = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected_1, cryptograph.offset_generator(date_1)
    assert_equal expected_1, cryptograph.offset_shift

    date_2 = "091920"
    expected_2 = {A: 6, B: 4, C: 0, D: 0}
    assert_equal expected_2, cryptograph.offset_generator(date_2)
    assert_equal expected_2, cryptograph.offset_shift
  end

  def test_generate_master_offset
    cryptograph = Cryptograph.new
    key = "02715"
    date = "040895"

    cryptograph.key_generator(key)
    assert_equal ({A: 2, B: 27, C: 71, D: 15}), cryptograph.key_shift

    cryptograph.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), cryptograph.offset_shift

    cryptograph.generate_master_offset

    assert_equal ({A: 3, B: 27, C: 73, D: 20}), cryptograph.master_shift
  end

  def test_split_string
    cryptograph = Cryptograph.new
    string_1 = "HeLlO wOrLd"
    expected_1 = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected_1, cryptograph.split_string(string_1)

    string_2 = "keder ohulw"
    expected_2 = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected_2, cryptograph.split_string(string_2)
  end

  def test_match_letter_to_shift
    cryptograph = Cryptograph.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    cryptograph.key_generator(key)
    cryptograph.offset_generator(date)
    cryptograph.generate_master_offset
    assert_equal ({A: 3, B: 27, C: 73, D:20}), cryptograph.master_shift

    expected = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    actual = cryptograph.match_letter_to_shifts(message)
    assert_equal expected, actual
  end
end