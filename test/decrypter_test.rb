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

  def test_match_letter_to_shift
    skip
    decrypter = Decrypter.new
    string = "keder ohulw"
    decrypter.stubs(:random_number_generator).returns("02715")
    decrypter.stubs(:date_conversion).returns("040895")

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected_1, decrypter.master_shift_count

    expected_2 = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    assert_equal expected_2, decrypter.match_letter_to_shifts(string)
  end

  def test_offset_generator
    decrypter = Decrypter.new
    decrypter.stubs(:date_conversion).returns("040895")
    expected = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected, decrypter.offset_generator
  end
end