# #!/usr/bin/env rake
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end
# begin
#   require 'rdoc/task'
# rescue LoadError
#   require 'rdoc/rdoc'
#   require 'rake/rdoctask'
#   RDoc::Task = Rake::RDocTask
# end
# 
# RDoc::Task.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'Burp'
#   rdoc.options << '--line-numbers'
#   rdoc.rdoc_files.include('README.rdoc')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
# 
# require 'jeweler'
# Jeweler::Tasks.new do |gem|
#   # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
#   gem.name = "burp"
#   # gem.homepage = "http://github.com/bjornblomqvist/burp"
#   gem.license = "LGPL3"
#   gem.summary = %Q{ A CMS that tryes hard to not get in your way! }
#   gem.description = %Q{ A CMS that tryes hard to not get in your way! }
#   gem.email = "darwin@bits2life.com"
#   gem.authors = ["Darwin"]
#   gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
#   # dependencies defined in Gemfile
# end
# Jeweler::RubygemsDotOrgTasks.new
# # 
# # APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
# # load 'rails/tasks/engine.rake'
# # 
# # Bundler::GemHelper.install_tasks
# # 
# # require 'rake/testtask'
# # 
# # Rake::TestTask.new(:test) do |t|
# #   t.libs << 'lib'
# #   t.libs << 'test'
# #   t.pattern = 'test/**/*_test.rb'
# #   t.verbose = false
# # end
# # 
# # 
# # task :default => :test

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
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "burp"
  # gem.homepage = "http://github.com/bjornblomqvist/burp"
  gem.license = "LGPL3"
  gem.summary = %Q{ A CMS that tryes hard to not get in your way! }
  gem.description = %Q{ A CMS that tryes hard to not get in your way! }
  gem.email = "darwin@bits2life.com"
  gem.authors = ["Darwin"]
  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
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
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mayi #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

