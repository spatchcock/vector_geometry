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
  gem.name = "vector_geometry"
  gem.homepage = "https://github.com/spatchcock/vector_geometry"
  gem.license = "GNU Affero General Public License"
  gem.summary = %Q{Cartesian and spherical geometry using vectors}
  gem.description = %Q{Cartesian and spherical geometry using vectors}
  gem.email = "andrew.berkeley.is@googlemail.com"
  gem.authors = ["Andrew Berkeley"]
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
RDoc::Task.new do |rd|
  rd.title = "Vector Geometry"
  rd.rdoc_dir = 'doc'
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
end