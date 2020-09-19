class Encrypt
  def initialize

  end

  def random_number_generator
    rand.to_s[2..6]
  end

  def generate_keys
    rand_num = random_number_generator
    placements = [rand_num[0..1], rand_num[1..2], rand_num[2..3], rand_num[3..4]]
    placements.map! {|placement| placement.to_i}
    letter_keys = [:A, :B, :C, :D]
    encryption_keys = Hash[letter_keys.zip(placements)]
  end
end