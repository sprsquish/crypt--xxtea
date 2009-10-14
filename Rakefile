require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'crypt-tea'
    gem.summary = 'xxTEA implemented in pure ruby'
    gem.description = "An implementation of the Tiny Encryption Algorithm that's compatible with PHP's xxTEA"
    
    gem.email = 'sprsquish@gmail.com'
    gem.homepage = 'http://crypt-tea.rubyforge.org'
    gem.authors = ['Jeff Smick']

    gem.rubyforge_project = 'crypt-tea'

    gem.files = FileList['bin/**/*', 'lib/**/*'].to_a

    gem.test_files = FileList['test/**/*.rb']

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end  

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.rcov_opts += ['--exclude \/Library\/Ruby,test\/', '--xrefs']
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end



require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "blather #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options += %w[-S --main README.rdoc]
end

task :default => :test
