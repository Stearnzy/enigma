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

  # def test_random_number_generator
  #   decrypter = Decrypter.new
  #   decrypter.stubs(:random_number_generator).returns("02715")
  #   assert_equal "02715", decrypter.random_number_generator
  # end
  #
  # def test_random_number_always_returns_5_digits
  #   decrypter = Decrypter.new
  #   pass = 0
  #   fail = 0
  #   2000.times do
  #     s = decrypter.random_number_generator
  #     if s.length == 5
  #       pass += 1
  #     else
  #       fail += 1
  #     end
  #   end
  #
  #   assert_equal 0, fail
  #   assert_equal 2000, pass
  # end

  def test_split_string
    decrypter = Decrypter.new
    expected = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected, decrypter.split_string("keder ohulw")
  end

  def test_offset_generator
    decrypter = Decrypter.new
    date = "040895"
    expected = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected, decrypter.offset_generator(date)
  end

  def test_key_generator
    decrypter = Decrypter.new
    key = "02715"
    expected = {:A=>2, :B=>27, :C=>71, :D=>15}
    assert_equal expected, decrypter.key_set_generator(key)
  end

  def test_master_shift_count
    decrypter = Decrypter.new
    key = "02715"
    date = "040895"

    expected = {A: 3, B: 27, C: 73, D:20}
    actual = decrypter.master_shift_count(decrypter.key_set_generator(key),
              decrypter.offset_generator(date))
    assert_equal expected, actual
  end

  def test_match_letter_to_shift
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    actual = decrypter.master_shift_count(decrypter.key_set_generator(key),
              decrypter.offset_generator(date))
    assert_equal expected_1, actual

    expected_2 = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    actual = decrypter.match_letter_to_shifts(message)
    assert_equal expected_2, actual
  end

  def test_total_shifts_per_character
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"
    decrypter.master_shift_count(decrypter.key_set_generator(key), decrypter.offset_generator(date))

    expected = [13, 31, 76, 24, 20, 53, 87, 27, 23, 38, 95]
    decrypter.index_shifts_per_character(message)
  end

  def test_decrypt
    skip
    decrypter = Decrypter.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    assert_equal "hello world", decrypter.decrypt(message, key, date)
  end
end