require_relative "000001_hex-to-base64"

module XORCipher
  def self.decrypt(hex)
    hex_bits = HexToBase64.hex_to_bits(hex)

    # this is the number of times the cipher_bits will repeat
    multiplier = hex.length / 2

    # for each possible cipher char, convert to bits
    # and repeat the bits until they have the same
    # length as `hex_bits`
    # xor the two strings and convert the result to ascii text
    possible_outputs = (0..255).map do |num|
      cipher_bits = dec_to_bits(num)
      cipher_bits_series = cipher_bits * multiplier

      xor_results = xor_bits(hex_bits, cipher_bits_series)

      bits_to_ascii(xor_results)
    end

    # rank outputs by frequency analysis score (descending)
    ranked_outputs = possible_outputs.sort_by do |output|
      frequency_match_score(output)
    end.reverse

    # print N outputs with the highest scores
    ranked_outputs.take(10).each_with_index do |output, idx|
      puts "#{idx + 1} | #{frequency_match_score(output)} | #{output}"
    end
  end

  def self.bits_to_ascii(bits)
    bit_groups = HexToBase64.bit_groups(bits, 8)

    chars = bit_groups.map do |bit_group|
      base10_num = HexToBase64.bits_to_base10(bit_group)
      base10_num.chr
    end

    chars.join("")
  end

  def self.chars_by_frequency(str)
    alpha = ("a".."z").to_a
    chars = str.downcase.split("")
    char_counts = {}
    
    chars.each do |char|
      next unless alpha.include?(char)
      if char_counts[char]
        char_counts[char] += 1
      else
        char_counts[char] = 1
      end
    end

    sorted_alpha = alpha.sort_by do |char|
      char_counts[char] || 0
    end.reverse

    sorted_alpha
  end

  def self.dec_to_bits(num)
    bits = []

    7.downto(0).each do |exp|
      binary_digit = num / (2**exp)
      bits << binary_digit
      num -= (binary_digit * (2**exp))
    end

    bits
  end

  def self.frequency_match_score(str)
    top_6 = %w(e t a o i n)
    bottom_6 = %w(v k j x q z)

    str = str.downcase

    chars_by_frequency = chars_by_frequency(str)
    top_6_in_str = chars_by_frequency.take(6)
    bottom_6_in_str = chars_by_frequency.last(6)

    top_6_score = (top_6 & top_6_in_str).count
    bottom_6_score = (bottom_6 & bottom_6_in_str).count

    top_6_score + bottom_6_score
  end

  def self.xor_bits(bits1, bits2)
    bits1.map.with_index do |bit, idx|
      bit ^ bits2[idx]
    end
  end
end

message = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
XORCipher.decrypt(message)
