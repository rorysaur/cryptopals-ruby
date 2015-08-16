require_relative "000001_hex-to-base64"

module FixedXOR
  def self.dec_to_hex_dict
    nums = ("0".."9").to_a
    letters = ("a".."f").to_a

    nums + letters
  end

  def self.bits_to_hex(bits)
    # split bits into groups
    bit_groups = HexToBase64.bit_groups(bits, 4)

    # map each group to a hex value
    hex_dict = dec_to_hex_dict()
    hex_values = bit_groups.map do |bit_group|
      base10_num = HexToBase64.bits_to_base10(bit_group)
      hex_dict[base10_num]
    end

    hex_values.join("")
  end

  def self.fixed_xor(hex1, hex2)
    # convert each hex to bits
    bits1 = HexToBase64.hex_to_bits(hex1)
    bits2 = HexToBase64.hex_to_bits(hex2)

    # xor the bits
    xor_result = bits1.map.with_index do |bit, idx|
      bit ^ bits2[idx]
    end

    # convert the result back to hex
    bits_to_hex(xor_result)
  end
end

hex1 = "1c0111001f010100061a024b53535009181c"
hex2 = "686974207468652062756c6c277320657965"
result = "746865206b696420646f6e277420706c6179"
p FixedXOR.fixed_xor(hex1, hex2) == result
