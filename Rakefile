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
