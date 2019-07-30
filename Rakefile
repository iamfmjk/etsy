#!/usr/bin/env rake
require 'rubygems'
require 'rake/testtask'
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

task :default => [:test, :spec]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = false
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

namespace :spec do
  desc "Setup specs"
  task :setup do
    require 'oauth'
    require './lib/etsy/client'
    key = ENV["ETSY_API_KEY"]
    unless key
      puts
      puts "No API key found. Run (or add to .bashrc):"
      puts "  export ETSY_API_KEY=<your api key>"
    end

    secret = ENV["ETSY_API_SECRET"]
    unless secret
      puts
      puts "For authenticated (oauth) requests, you also need a secret"
      puts "  export ETSY_API_SECRET=<your api secret>"
    end

    environment = ENV["ETSY_ENVIRONMENT"]
    unless environment
      puts
      puts "Defaulting to production environment. To override:"
      puts "  export ETSY_ENVIRONMENT=sandbox"
    end

    client = Etsy::Client.new(:api_key => key, :api_secret => secret)

    req = client.request_token

    puts "Go to:"
    puts req.params[:login_url]
    print "What is the verifier key? "
    verifier = STDIN.gets.chomp.strip
    token, secret = client.oauth_token(req, verifier)

    puts
    puts "These are your environment variables: "
    puts "export ETSY_OAUTH_TOKEN=#{token}"
    puts "export ETSY_OAUTH_SECRET=#{secret}"
    puts "export ETSY_OAUTH_VERIFIER=#{verifier}"
    puts
  end
end
