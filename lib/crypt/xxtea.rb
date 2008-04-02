module Crypt
  class XXTEA
    VERSION = '1.0.0'
    DELTA = 0x9E3779B9

    def self.str_to_longs(s, include_count = false)
      length = s.length
      ((4 - s.length % 4) & 3).times { s << "\0" } # Pad to a multiple of 4
      unpacked = s.unpack('V*').collect { |n| int32 n }
      unpacked << length if include_count
      unpacked
    end

    def self.longs_to_str(l, unpad = false)   # convert array of longs back to string
      s = l.pack('V*')
      s = s.gsub(/[\000-\037]/,'') if unpad
      s
    end


    def self.int32(n)
      n -= 4294967296 while (n >= 2147483648)
      n += 4294967296 while (n <= -2147483649)
      n.to_i
    end


    def initialize(new_key)
      @key = self.class.str_to_longs(new_key, false)

      if @key.length > 4
        raise 'Key is too long (no more than 16 chars)'

      elsif @key.length == 0
        raise 'Key cannot be empty'

      elsif @key.length < 4
        @key.length.upto(4) { |i| @key[i] = 0 }

      end
    end

    def encrypt(plaintext)
      return '' if plaintext.length == 0

      v = self.class.str_to_longs(plaintext, true)
      v[1] = 0 if v.length == 1

      n = v.length - 1

      z = v[n]
      y = v[0]
      q = (6 + 52/ (n + 1)).floor
      sum = 0
      p = 0

      while(0 <= (q -= 1)) do
        sum = self.class.int32(sum + DELTA)
        e = sum >> 2 & 3

        (0...n).each do |p|
          y = v[p + 1];
          mx =
            self.class.int32(
              ((z >> 5 & 0x07FFFFFF) ^ y << 2) +
              ((y >> 3 & 0x1FFFFFFF) ^ z << 4)
            ) ^ self.class.int32((sum ^ y) + (@key[p & 3 ^ e] ^ z))

          z = v[p] = self.class.int32(v[p] + mx)
        end

        p += 1
        y = v[0];
        mx =
          self.class.int32(
            ((z >> 5 & 0x07FFFFFF) ^ y << 2) +
            ((y >> 3 & 0x1FFFFFFF) ^ z << 4)
          ) ^ self.class.int32((sum ^ y) + (@key[p & 3 ^ e] ^ z))

        z = v[p] = self.class.int32(v[p] + mx)
      end

      self.class.longs_to_str(v).unpack('a*').pack('m').delete("\n") # base64 encode it without newlines
    end

    #
    # decrypt: Use Corrected Block TEA to decrypt ciphertext using password
    #
    def decrypt(ciphertext)
      return '' if ciphertext.length == 0

      v = self.class.str_to_longs(ciphertext.unpack('m').pack("a*"))   # base64 decode and convert to array of 'longs'
      n = v.length - 1
      z = v[n]
      y = v[0]
      q = (6 + 52 / (n + 1)).floor
      sum = self.class.int32(q * DELTA)
      p = 0

      while (sum != 0) do
        e = sum >> 2 & 3
        n.downto(1) do |p|
          z = v[p - 1]
          mx =
            self.class.int32(
              ((z >> 5 & 0x07FFFFFF) ^ y << 2) +
              ((y >> 3 & 0x1FFFFFFF) ^ z << 4)
            ) ^ self.class.int32((sum ^ y) + (@key[p & 3 ^ e] ^ z))

          y = v[p] = self.class.int32(v[p] - mx)
        end

        p -= 1
        z = v[n]
        mx =
          self.class.int32(
            ((z >> 5 & 0x07FFFFFF) ^ y << 2) +
            ((y >> 3 & 0x1FFFFFFF) ^ z << 4)
          ) ^ self.class.int32((sum ^ y) + (@key[p & 3 ^ e] ^ z))

        y = v[0] = self.class.int32(v[0] - mx)
        sum = self.class.int32(sum - DELTA)
      end

      self.class.longs_to_str(v, true)
    end

  end
end
