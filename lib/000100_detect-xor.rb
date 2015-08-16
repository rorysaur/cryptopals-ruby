require_relative "000011_xor-cipher"

module DetectXOR
  def self.detect(filename)
    decrypted_lines = []

    File.foreach(filename).with_index do |line, idx|
      line = line.chomp
      best_decryptions = XORCipher.decrypt(line)
      best_decryptions.each do |decryption|
        decrypted_line = {
          :text => decryption[:text],
          :score => decryption[:score],
          :index => idx
        }

        decrypted_lines << decrypted_line
      end
    end

    ranked_decrypted_lines = decrypted_lines.sort_by do |line|
      line[:score]
    end.reverse

    ranked_decrypted_lines.each do |line|
      puts "#{line[:score]} | #{line[:text]} | #{line[:index]}"
    end
  end
end

DetectXOR.detect("files/000100_detect-xor.txt")
