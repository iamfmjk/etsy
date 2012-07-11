#!/usr/bin/env rake
require 'rubygems'
require 'rake/testtask'
require "bundler/gem_tasks"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc "Cleans out the api credentials from the code"
task :clean do
  puts "Cleaning out api credentials from project...."
  require File.join(File.dirname(__FILE__), 'spec/api_credentials')

  `find spec/cassettes/*.yml -exec sed -i '' 's/#{API_KEY}/API_KEY/' {} \\;`
  puts "DONE"
end

desc "Restores the api keys from the api_credentials file"
task :unclean do
  puts "Restoring credentials"
  require File.join(File.dirname(__FILE__), 'spec/api_credentials')

  `find spec/cassettes/*.yml -exec sed -i '' 's/API_KEY/#{API_KEY}/' {} \\;`
  puts "DONE"
end
