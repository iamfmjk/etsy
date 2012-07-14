# -*- encoding: utf-8 -*-
require File.expand_path('../lib/etsy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Patrick Reagan", "Katrina Owen"]
  gem.email         = ["reaganpr@gmail.com", "katrina.owen@gmail.com"]
  gem.description   = %q{A friendly Ruby interface to the Etsy API}
  gem.summary       = %q{Provides a friendly ruby-like wrapper for the Etsy API}
  gem.homepage      = "http://github.com/kytrinyx/etsy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "etsy"
  gem.require_paths = ["lib"]
  gem.version       = Etsy::VERSION

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.rubygems_version = "1.8.10"

  gem.add_dependency "json", ">= 1.5.0"
  gem.add_dependency "oauth", "~> 0.4.0"
  gem.add_dependency "faraday", "~> 0.8.0"
  gem.add_dependency "faraday_middleware", "~> 0.8.8"

  gem.add_development_dependency "rake", "~> 0.9.2.2"
  gem.add_development_dependency "jnunemaker-matchy", "~> 0.4.0"
  gem.add_development_dependency "shoulda", "~> 3.0.0"
  gem.add_development_dependency "mocha", "~> 0.12.0"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "vcr", "~> 2.2.3"
  gem.add_development_dependency "simplecov", "~> 0.6.4"
end
