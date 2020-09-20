class Cryptograph
    attr_reader :alphabet, :master_shift, :key_shift, :offset_shift

  def initialize
    @letter_keys = [:A, :B, :C, :D]
    @alphabet = ("a".."z").to_a << ' '
    @master_shift = nil
    @key_shift = nil
    @offset_shift = nil
  end
end