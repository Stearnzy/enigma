require "minitest/autorun"
require "minitest/pride"
require "./lib/cryptograph"

class CryptographTest < Minitest::Test
  def test_it_exists
    cryptograph = Cryptograph.new
    assert_instance_of Cryptograph, cryptograph
  end
end