module HexToBase64
  # Returns an array where each index corresponds to a base64-encoded value.
  #
  # @return [Array<String>]
  def self.base64_dict
    caps = ("A".."Z").to_a
    lowercase = ("a".."z").to_a
    nums = ("0".."9").to_a
    symbols = %w(+ /)

    chars = caps + lowercase + nums + symbols

    chars
  end

  # Converts an array of 6 bits to a base10 value.
  #
  # @param [Array<Integer>] bits an array of 6 integers, either 0 or 1
  # @return [Integer]
  #
  # @example
  #   bits_to_base10([0, 1, 0, 0, 1, 0] # => 18
  def self.bits_to_base10(bits)
    base10 = 0
    max_exp = bits.count - 1

    bits.each_with_index do |bit, idx|
      exp = max_exp - idx
      base10 += bit * (2**exp)
    end

    base10
  end

  # Returns a hash with hexadecimal digits as keys their corresponding base10 values.
  #
  # @return [Hash{String => Integer}]
  def self.hex_dict
    nums = ("0".."9").to_a
    letters = ("a".."f").to_a
    keys = nums + letters

    dict = {}

    keys.each_with_index do |key, idx|
      dict[key] = idx
    end

    dict
  end

  # Accepts a string of hexadecimal digits and converts it to an array of bits.
  #
  # @param [String] hex a string of hexadecimal digits
  # @return [Array<Integer>] an array of integers with values 0 or 1
  #
  # @example
  #   hex_to_bits("4") # => [0, 1, 0, 0]
  def self.hex_to_bits(hex)
    digits = hex.split("")
    hex_dict = hex_dict()
    bits = []

    digits.each do |digit|
      base10_num = hex_dict[digit]

      3.downto(0).each do |exp|
        binary_digit = base10_num / (2**exp)
        bits << binary_digit
        base10_num -= (binary_digit * (2**exp))
      end
    end

    bits
  end

  # From left to right, groups each set of N elements into an array,
  # and returns the array of arrays. Pads the last array with zeroes
  # if necessary to match the group size N.
  #
  # @param [Array<Integer>] bits an array of integers with values 0 or 1
  # @param [Integer] group_size the number of items in each group
  # @return [Array<Array<Integer>>]
  #
  # @example
  #   bit_groups([0, 1, 1, 1], 2) # => [[0, 1], [1, 1]]
  # @example
  #   bit_groups([0, 1, 1], 2) # => [[0, 1], [1, 0]]
  def self.bit_groups(bits, group_size)
    bit_groups = []
    current_bit_group = [bits.first]

    bits.each_with_index do |bit, idx|
      if idx % group_size == 0
        bit_groups << current_bit_group unless idx == 0
        current_bit_group = [bit]
        next
      else
        current_bit_group << bit
      end
    end

    bit_groups << current_bit_group

    # pad last group if necessary
    while bit_groups.last.count < group_size
      bit_groups.last << 0
    end

    bit_groups
  end

  # Encodes a string of hexadecimal digits to base64.
  #
  # @param [String] hex a string of hexadecimal digits
  # @return [String] a base64-encoded string
  def self.hex_to_base64(hex)
    bits = hex_to_bits(hex)

    bit_groups = bit_groups(bits, 6)

    base64_dict = base64_dict()

    encoded_chars = bit_groups.map do |bit_group|
      value = bits_to_base10(bit_group)
      base64_dict[value]
    end

    encoded_chars.join("")
  end
end

# test for `hex_to_base64` method
p HexToBase64.hex_to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d") == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
