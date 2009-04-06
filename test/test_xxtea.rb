$:.unshift File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'crypt_tea'

class XXTEATest < Test::Unit::TestCase
  def setup
    @key = Crypt::XXTEA.new 'abigfattestkey'
    @plaintext = "Oh say can you see, by the dawn's early light"
    @cyphertext = "V32cYZc5yLXepm9lxzr4kgGM/eSVurwV0yQWi4uFs0uB2UBlJ19ZRKKMkbMr7DLGc3n1XQ=="
  end

  def test_str_to_long
    assert_equal [1953719668, 6778473, 7], Crypt::XXTEA.str_to_longs('testing', true)
  end

  def test_longs_to_str
    assert_equal 'testing', Crypt::XXTEA.longs_to_str([1953719668, 6778473, 7], true)
  end

  def test_key_length
    assert_raise(RuntimeError) { Crypt::XXTEA.new '12345678901234567' }
    assert_raise(RuntimeError) { Crypt::XXTEA.new '' }
  end

  def test_encrypt
    assert_equal @cyphertext, @key.encrypt(@plaintext)
  end

  def test_decrypt
    assert_equal @plaintext, @key.decrypt(@cyphertext)
  end

  def test_tiny_plaintext
    assert_equal '1', @key.decrypt(@key.encrypt('1'))
  end

  def test_huge_plaintext
    str = '1234567890' * 1_000
    assert_equal str, @key.decrypt(@key.encrypt(str))
  end
end