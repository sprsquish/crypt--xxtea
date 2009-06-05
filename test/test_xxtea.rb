require 'rubygems'
require 'minitest/spec'
require File.join(File.dirname(__FILE__), *%w[.. lib crypt_tea])

MiniTest::Unit.autorun

describe Crypt::XXTEA do
  before do
    @key_text = 'abigfattestkey'
    @key = Crypt::XXTEA.new @key_text
    @plaintext = "Oh say can you see, by the dawn's early light"
    @cyphertext = "V32cYZc5yLXepm9lxzr4kgGM/eSVurwV0yQWi4uFs0uB2UBlJ19ZRKKMkbMr7DLGc3n1XQ=="
  end

  it 'converts strings to longs' do
    Crypt::XXTEA.str_to_longs('testing', true).must_equal [1953719668, 6778473, 7]
  end

  it 'converts longs to strings' do
    Crypt::XXTEA.longs_to_str([1953719668, 6778473, 7], true).must_equal 'testing'
  end

  it 'raises an error when the key is too long' do
    proc { Crypt::XXTEA.new '12345678901234567' }.must_raise RuntimeError
  end

  it 'raises an error when the key is blank' do
    proc { Crypt::XXTEA.new '' }.must_raise RuntimeError
  end

  it 'works properly with small keys' do
    key = Crypt::XXTEA.new '123'
    cyphertext = key.encrypt(@plaintext)
    key.decrypt(cyphertext).must_equal @plaintext
  end

  it 'properly encrypts when instantiated' do
    @key.encrypt(@plaintext).must_equal @cyphertext
  end

  it 'properly decrypts when instantiated' do
    @key.decrypt(@cyphertext).must_equal @plaintext
  end

  it 'properly en/decrypts tiny text' do
    txt = '1'
    @key.decrypt(@key.encrypt(txt)).must_equal txt
  end

  it 'properly en/decrypts huge text' do
    str = '1234567890' * 1_000
    @key.decrypt(@key.encrypt(str)).must_equal str
  end

  it 'properly encrypts with a class method' do
    Crypt::XXTEA.encrypt(@key_text, @plaintext).must_equal @cyphertext
  end

  it 'properly decrypts with a class method' do
    Crypt::XXTEA.decrypt(@key_text, @cyphertext).must_equal @plaintext
  end
end