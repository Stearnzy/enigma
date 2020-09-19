class Cryptograph
    attr_reader :alphabet

  def initialize
    @letter_keys = [:A, :B, :C, :D]
    @alphabet = ("a".."z").to_a << ' '
  end
end