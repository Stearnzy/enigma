require "./test/test_helper"

class EncrypterTest < Minitest::Test
  def test_it_exists
    encrypter = Encrypter.new
    assert_instance_of Encrypter, encrypter
  end

  def test_readable_alphabet
    encrypter = Encrypter.new
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, encrypter.alphabet
  end

  def test_shift_values_start_at_nil
    encrypter = Encrypter.new
    assert_nil encrypter.master_shift
    assert_nil encrypter.key_shift
    assert_nil encrypter.offset_shift
  end

  def test_random_number_generator
    encrypter = Encrypter.new
    encrypter.stubs(:random_number_generator).returns("02715")
    assert_equal "02715", encrypter.random_number_generator
  end

  def test_random_number_always_returns_5_digits
    encrypter = Encrypter.new
    pass = 0
    fail = 0
    2000.times do
      s = encrypter.random_number_generator
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
    encrypter = Encrypter.new
    encrypter.stubs(:random_number_generator).returns("02715")

    expected_1 = {A: 2, B: 27, C: 71, D: 15}
    assert_equal expected_1, encrypter.key_generator

    expected_2 = {A: 6, B: 65, C: 59, D: 98}
    assert_equal expected_2, encrypter.key_generator("06598")
  end

  def test_square_date
    encrypter = Encrypter.new
    assert_equal "1672401025", encrypter.square_date("040895")

    assert_equal "8449286400", encrypter.square_date("091920")
  end

  def test_offset_generator
    encrypter = Encrypter.new
    date_1 = "040895"
    expected_1 = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected_1, encrypter.offset_generator(date_1)

    date_2 = "091920"
    expected_2 = {A: 6, B: 4, C: 0, D: 0}
  end

  def test_generate_master_offset
    encrypter = Encrypter.new
    encrypter.stubs(:random_number_generator).returns("02715")
    date = "040895"

    encrypter.key_generator
    assert_equal ({A: 2, B: 27, C: 71, D: 15}), encrypter.key_shift

    encrypter.offset_generator(date)
    assert_equal ({A: 1, B: 0, C: 2, D: 5}), encrypter.offset_shift

    encrypter.generate_master_offset

    assert_equal ({A: 3, B: 27, C: 73, D: 20}), encrypter.master_shift
  end

  def test_split_string
    encrypter = Encrypter.new
    string = "HeLlO wOrLd"
    expected = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected, encrypter.split_string(string)
  end

  def test_match_letter_to_shift
    encrypter = Encrypter.new
    string = "Hello World!!"

    encrypter.stubs(:random_number_generator).returns("02715")
    encrypter.key_generator

    date = "040895"
    encrypter.offset_generator(date)

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    actual_1 = encrypter.generate_master_offset
    assert_equal expected_1, actual_1

    expected_2 = [["h", [:A, 3]], ["e", [:B, 27]], ["l", [:C, 73]], ["l", [:D, 20]],
                ["o", [:A, 3]], [" ", [:B, 27]], ["w", [:C, 73]], ["o", [:D, 20]],
                ["r", [:A, 3]], ["l", [:B, 27]], ["d", [:C, 73]], ["!", [:D, 20]],
                ["!", [:A, 3]]]
    assert_equal expected_2, encrypter.match_letter_to_shifts(string)
  end

  def test_total_shifts_per_character
    encrypter = Encrypter.new
    string = "Hello World!!"

    encrypter.stubs(:random_number_generator).returns("02715")
    encrypter.key_generator

    date = "040895"
    encrypter.offset_generator(date)

    encrypter.generate_master_offset

    expected = [10, 31, 84, 31, 17, 53, 95, 34, 20, 38, 76, "!", "!"]
    assert_equal expected, encrypter.encrypt_index_shifts_per_character(string)
  end

  def test_index_mapping
    encrypter = Encrypter.new
    string = "Hello World!!"

    encrypter.stubs(:random_number_generator).returns("02715")
    encrypter.key_generator

    date = "040895"
    encrypter.offset_generator(date)

    encrypter.generate_master_offset

    guide = encrypter.encrypt_index_shifts_per_character(string)

    assert_equal "keder ohulw!!", encrypter.index_mapping(guide)
  end

  def test_encrypt
    encrypter = Encrypter.new
    encrypter.stubs(:random_number_generator).returns("02715")
    encrypter.stubs(:date_conversion).returns("040895")

    assert_equal "keder ohulw!!", encrypter.encrypt("Hello World!!")
  end
end