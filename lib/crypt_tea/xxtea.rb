module Crypt
  class XXTEA
    VERSION = '1.2.0'
    DELTA = 0x9E3779B9

    def initialize(new_key)
      @key = str_to_longs(new_key)

      if @key.length > 4
        raise 'Key is too long (no more than 16 chars)'

      elsif @key.length == 0
        raise 'Key cannot be empty'

      elsif @key.length < 4
        @key.length.upto(4) { |i| @key[i] = 0 }

      end
    end

    def self.str_to_longs(s, include_count = false)
      length = s.length
      ((4 - s.length % 4) & 3).times { s << "\0" } # Pad to a multiple of 4
      unpacked = s.unpack('V*').collect { |n| int32 n }
      unpacked << length if include_count
      unpacked
    end

    def str_to_longs(s, include_count = false)
      self.class.str_to_longs s, include_count
    end


    ##
    # convert array of longs back to string
    def self.longs_to_str(l, count_included = false)
      s = l.pack('V*')
      s = s[0...(l[-1])] if count_included
      s
    end

    def longs_to_str(l, count_included = false)
      self.class.longs_to_str l, count_included
    end


    def self.int32(n)
      n -= 4_294_967_296 while (n >= 2_147_483_648)
      n += 4_294_967_296 while (n <= -2_147_483_648)
      n.to_i
    end

    def int32(n)
      self.class.int32 n
    end

    def mx(z, y, sum, p, e)
      int32(
        ((z >> 5 & 0x07FFFFFF) ^ (y << 2)) +
        ((y >> 3 & 0x1FFFFFFF) ^ (z << 4))
      ) ^ int32((sum ^ y) + (@key[(p & 3) ^ e] ^ z))
    end

    def encrypt(plaintext)
      return '' if plaintext.length == 0

      v = str_to_longs(plaintext, true)
      v[1] = 0 if v.length == 1

      n = v.length - 1

      z = v[n]
      y = v[0]
      q = (6 + 52 / (n + 1)).floor
      sum = 0
      p = 0

      while(0 <= (q -= 1)) do
        sum = int32(sum + DELTA)
        e = sum >> 2 & 3

        n.times do |i|
          y = v[i + 1];
          z = v[i] = int32(v[i] + mx(z, y, sum, i, e))
          p = i
        end

        p += 1
        y = v[0];
        z = v[p] = int32(v[p] + mx(z, y, sum, p, e))
      end

      longs_to_str(v).unpack('a*').pack('m').delete("\n") # base64 encode it without newlines
    end

    #
    # decrypt: Use Corrected Block TEA to decrypt ciphertext using password
    #
    def decrypt(ciphertext)
      return '' if ciphertext.length == 0

      v = str_to_longs(ciphertext.unpack('m').pack("a*"))   # base64 decode and convert to array of 'longs'
      n = v.length - 1
      z = v[n]
      y = v[0]
      q = (6 + 52 / (n + 1)).floor
      sum = int32(q * DELTA)
      p = 0

      while (sum != 0) do
        e = sum >> 2 & 3
        n.downto(1) do |i|
          z = v[i - 1]
          y = v[i] = int32(v[i] - mx(z, y, sum, i, e))
          p = i
        end

        p -= 1
        z = v[n]
        y = v[0] = int32(v[0] - mx(z, y, sum, p, e))
        sum = int32(sum - DELTA)
      end

      longs_to_str(v, true)
    end

  end
end
