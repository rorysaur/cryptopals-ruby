require_relative "./test_helper"
require_relative "../lib/000001_hex-to-base64"

class TestHexToBase64 < Minitest::Test
  def setup
  end

  def hex_input
    "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  end

  def expected_base64_output
    "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
  end

  def test_hex_to_base64
    assert_equal HexToBase64.hex_to_base64(hex_input), expected_base64_output
  end
end
