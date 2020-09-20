class Cryptograph
    attr_reader :alphabet

  def initialize
    @letter_keys = [:A, :B, :C, :D]
    @alphabet = ("a".."z").to_a << ' '
    @master_key_shift = nil
  end
end