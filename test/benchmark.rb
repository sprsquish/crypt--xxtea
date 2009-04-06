require 'benchmark'

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'crypt_tea'

GC.disable

@key = Crypt::XXTEA.new 'abigfattestkey'

Benchmark.bm do |x|
  x.report('1') { str = '1'; @key.decrypt(@key.encrypt(str)) }
  x.report('10') { str = '1' * 10; @key.decrypt(@key.encrypt(str)) }
  x.report('100') { str = '1' * 100; @key.decrypt(@key.encrypt(str)) }
  x.report('1_000') { str = '1' * 1_000; @key.decrypt(@key.encrypt(str)) }
  x.report('10_000') { str = '1' * 10_000; @key.decrypt(@key.encrypt(str)) }
  x.report('100_000') { str = '1' * 100_000; @key.decrypt(@key.encrypt(str)) }
end
