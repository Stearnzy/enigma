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

  # def test_random_number_generator
  #   decryptor = Decryptor.new
  #   decryptor.stubs(:random_number_generator).returns("02715")
  #   assert_equal "02715", decryptor.random_number_generator
  # end
  #
  # def test_random_number_always_returns_5_digits
  #   decryptor = Decryptor.new
  #   pass = 0
  #   fail = 0
  #   2000.times do
  #     s = decryptor.random_number_generator
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
    decryptor = Decryptor.new
    expected = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    assert_equal expected, decryptor.split_string("keder ohulw")
  end

  def test_match_letter_to_shift
    decryptor = Decryptor.new
    string = "keder ohulw"
    decryptor.stubs(:random_number_generator).returns("02715")
    decryptor.stubs(:date_conversion).returns("040895")

    expected_1 = {A: 3, B: 27, C: 73, D:20}
    assert_equal expected_1, decryptor.master_shift_count

    expected_2 = [["k", [:A, 3]], ["e", [:B, 27]], ["d", [:C, 73]], ["e", [:D, 20]],
                ["r", [:A, 3]], [" ", [:B, 27]], ["o", [:C, 73]], ["h", [:D, 20]],
                ["u", [:A, 3]], ["l", [:B, 27]], ["w", [:C, 73]]]
    assert_equal expected_2, decryptor.match_letter_to_shifts(string)
  end

  def test_offset_generator
    decryptor = Decryptor.new
    decryptor.stubs(:date_conversion).returns("040895")
    expected = {A: 1, B: 0, C: 2, D: 5}
    assert_equal expected, decryptor.offset_generator
  end
end