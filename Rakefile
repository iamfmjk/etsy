#!/usr/bin/env rake
require 'rubygems'
require 'rake/testtask'
require "bundler/gem_tasks"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = false
end
