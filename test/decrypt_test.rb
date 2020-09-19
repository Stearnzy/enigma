require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/decrypt"

class DecryptTest < Minitest::Test
  def test_it_exists
    decrypt = Decrypt.new
    assert_instance_of Decrypt, decrypt
  end
end