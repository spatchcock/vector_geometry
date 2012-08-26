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
require 'rspec'
require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end

require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "math-function"
  gem.homepage = "https://github.com/spatchcock/math-function"
  gem.license = "GNU Affero General Public License"
  gem.summary = %Q{Define and evaluate arbitrary mathematical functions in Ruby}
  gem.description = %Q{Define and evaluate arbitrary mathematical functions in Ruby}
  gem.email = "andrew.berkeley.is@googlemail.com"
  gem.authors = ["Andrew Berkeley"]
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
RDoc::Task.new do |rd|
  rd.title = "Math-function"
  rd.rdoc_dir = 'doc'
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
end