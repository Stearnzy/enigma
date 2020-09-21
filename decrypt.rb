require './lib/enigma'

enigma = Enigma.new

handle = File.open(ARGV[0], "r")

incoming_text = handle.read

handle.close

require "pry"; binding.pry
decrypted_text = enigma.decrypt(incoming_text[:encryption], incoming_text[:key], incoming_text[:date])

writer = File.open(ARGV[1], "w")

writer.write(decrypted_text)

writer.close

p "Created '#{ARGV[1]}' with the key #{ARGV[2]} and date #{ARGV[3]}"