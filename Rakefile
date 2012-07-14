#!/usr/bin/env rake
require 'rubygems'
require 'rake/testtask'
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

task :default => [:test, :spec]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

desc "Cleans out the api credentials from the code"
task :clean do
  print "Cleaning out api credentials from project....  "
  require File.join(File.dirname(__FILE__), 'spec/api_credentials')

  `find spec/cassettes/*.yml -exec sed -i '' 's/#{API_KEY}/API_KEY/' {} \\;`
  puts "DONE"
end

desc "Restores the api keys from the api_credentials file"
task :unclean do
  print "Restoring credentials....  "
  require File.join(File.dirname(__FILE__), 'spec/api_credentials')

  `find spec/cassettes/*.yml -exec sed -i '' 's/API_KEY/#{API_KEY}/' {} \\;`
  puts "DONE"
end
