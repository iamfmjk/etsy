require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require File.dirname(__FILE__) + "/lib/etsy/version"

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'etsy'
  s.version          = Etsy::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "Provides a friendly ruby-like interface to the Etsy API"
  s.author           = 'Patrick Reagan'
  s.email            = 'reaganpr@gmail.com'
  s.homepage         = 'http://sneaq.net'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib,test}/**/*")

  s.add_dependency('json-jruby', '~> 1.4.3')
  s.add_dependency('oauth', '~> 0.3.5')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec for this Gem'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end
