# encoding: utf-8

require 'rubygems'
require 'bundler'


begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
require 'burp/version'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "burp_cms"
  # gem.homepage = "http://github.com/bjornblomqvist/burp"
  gem.license = "LGPL3"
  gem.summary = %Q{ A CMS that tryes hard to not get in your way! }
  gem.description = %Q{ A CMS that tryes hard to not get in your way! }
  gem.email = "darwin@bits2life.com"
  gem.authors = ["Darwin"]
  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.version     = Burp::VERSION
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version =  Burp::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mayi #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

