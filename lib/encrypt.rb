require './lib/enigma'

enigma = Enigma.new

handle = File.open(ARGV[0], "r")
message = handle.read
handle.close

encrypt_info = enigma.encrypt(message)
encrypted_text = encrypt_info[:encryption]

writer = File.open(ARGV[1], "w")
writer.write(encrypted_text)
writer.close

p "Created '#{ARGV[1]}' with the key #{encrypt_info[:key]} and date #{encrypt_info[:date]}"