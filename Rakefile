require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "kakadoer"
    gem.summary = %Q{Simple wrapper around kakadu_compress}
    gem.description = %Q{Simple wrapper around kakadu_compress to convert a batch of TIFs to JP2s}
    gem.email = "jronallo@gmail.com"
    gem.homepage = "http://github.com/jronallo/kakadoer"
    gem.authors = ["Jason Ronallo"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency "trollop", ">= 0"
    gem.add_dependency "rmagick"
    gem.files = FileList["[A-Z]*", "{bin,lib}/**/*"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "kakadoer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
