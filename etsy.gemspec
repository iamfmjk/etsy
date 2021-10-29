# -*- encoding: utf-8 -*-
require File.expand_path('../lib/etsy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Iuliia Kolomiiets", "Patrick Reagan", "Katrina Owen"]
  gem.email         = ["etsygeminfo@gmail.com, reaganpr@gmail.com", "katrina.owen@gmail.com" ]
  gem.description   = %q{A friendly Ruby interface to the Etsy API}
  gem.summary       = %q{Provides a friendly ruby-like wrapper for the Etsy API}
  gem.homepage      = "http://github.com/kytrinyx/etsy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "etsy"
  gem.require_paths = ["lib"]
  gem.version       = Etsy::VERSION
  gem.license       = 'MIT'

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.rubygems_version = "1.8.10"

  gem.add_dependency "json", ">= 1.5.0"
  gem.add_dependency "oauth", ">= 0.5.5"

  gem.add_development_dependency "rake", "~> 12.3.3"
  gem.add_development_dependency "jnunemaker-matchy", "~> 0.4.0"
  gem.add_development_dependency 'shoulda', "~> 3.4.0"
  gem.add_development_dependency 'mocha', "~> 0.13.3"
  # shoulda-context blows up on ActiveSupport not being defined
  # on shoulda/context.rb:7
  # But then when you load active_support, shoulda-context decides
  # to load MiniTest
  gem.add_development_dependency 'test-unit', "~>3.5.0"
end
