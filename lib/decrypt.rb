require './lib/enigma'

enigma = Enigma.new

handle = File.open(ARGV[0], "r")

encrypted_message = handle.read

handle.close

decrypted_info = enigma.decrypt(encrypted_message, ARGV[2], ARGV[3])

writer = File.open(ARGV[1], "w")

writer.write(decrypted_info[:decryption])

writer.close

p "Created '#{ARGV[1]}' with the key #{ARGV[2]} and date #{ARGV[3]}"