# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{crypt-tea}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Smick"]
  s.date = %q{2009-06-05}
  s.default_executable = %q{xxtea}
  s.description = %q{An implementation of the Tiny Encryption Algorithm that's compatible with PHP's xxTEA}
  s.email = %q{sprsquish@gmail.com}
  s.executables = ["xxtea"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "bin/xxtea",
     "lib/crypt_tea.rb",
     "lib/crypt_tea/xxtea.rb"
  ]
  s.homepage = %q{http://crypt-tea.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{crypt-tea}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{xxTEA implemented in pure ruby}
  s.test_files = [
    "test/benchmark.rb",
     "test/test_xxtea.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
