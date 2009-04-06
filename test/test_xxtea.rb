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
    assert_equal [1953719668, 6778473], Crypt::XXTEA.str_to_longs('testing')
  end

  def test_longs_to_str
    assert_equal 'testing', Crypt::XXTEA.longs_to_str([1953719668, 6778473], true)
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

  def test_different_size_plaintext
    assert_equal '123', @key.decrypt(@key.encrypt('123'))
    assert_equal '1234567890', @key.decrypt(@key.encrypt('1234567890'))
    assert_equal 'abcdefghijklmnopqrstuvwxyz', @key.decrypt(@key.encrypt('abcdefghijklmnopqrstuvwxyz'))
    assert_equal '12345678901234567890123456789012', @key.decrypt(@key.encrypt('12345678901234567890123456789012'))
  end
end