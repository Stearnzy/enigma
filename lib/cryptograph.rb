class Cryptograph
    attr_reader :alphabet, :master_shift, :key_shift, :offset_shift

  def initialize
    @letter_keys = [:A, :B, :C, :D]
    @alphabet = ("a".."z").to_a << ' '
    @master_shift = nil
    @key_shift = nil
    @offset_shift = nil
  end

  def random_number_generator
    rand.to_s[2..6]
  end
end