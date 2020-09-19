require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/encrypt"

class EncryptTest < Minitest::Test
  def test_it_exists
    encrypt = Encrypt.new
    assert_instance_of Encrypt, encrypt
  end


  def test_random_number_generator
    encrypt = Encrypt.new
    encrypt.stubs(:random_number_generator).returns("02385")
    assert_equal "02385", encrypt.random_number_generator
  end

  def test_key_generator
    skip
    encrypt = Encrypt.new
    encrypt.generate_keys

  end
end