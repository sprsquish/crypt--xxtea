$:.unshift File.dirname(__FILE__) + '/../lib'

require 'test/unit'
require 'crypt_tea'

class XXTEATest < Test::Unit::TestCase
  def setup
    @key = Crypt::XXTEA.new 'testkey'
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
    assert_equal 'qYkeGc3ignEvPGM7RS06iQ==', @key.encrypt('plaintext')
  end

  def test_decrypt
    assert_equal 'plaintext', @key.decrypt('qYkeGc3ignEvPGM7RS06iQ==')
  end
end