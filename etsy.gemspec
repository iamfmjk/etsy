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
  gem.license       = 'MIT'

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.rubygems_version = "1.8.10"

  gem.add_dependency "json", ">= 1.5.0"
  gem.add_dependency "oauth", "~> 0.4.0"
  gem.add_dependency "faraday", "~> 0.8.0"
  gem.add_dependency "faraday_middleware", "~> 0.8.8"
  gem.add_dependency "simple_oauth", "~> 0.1.8"
  gem.add_dependency "jruby-openssl", "~> 0.7.7" if RUBY_PLATFORM == 'java'

  gem.add_development_dependency "rake", "~> 10.0.4"
  gem.add_development_dependency "jnunemaker-matchy", "~> 0.4.0"
  # rspec version > 2.7.x breaks with jruby
  # see http://jira.codehaus.org/browse/JRUBY-6324
  # apparently this has been fixed. See http://jira.codehaus.org/browse/JRUBY-6324?focusedCommentId=287912&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-287912
  gem.add_development_dependency "rspec", "~> 2.12.0"
  gem.add_development_dependency "vcr", "~> 2.2.3"
  gem.add_development_dependency "webmock", "~> 1.8.7"
  gem.add_development_dependency "simplecov", "~> 0.6.4"
  gem.add_development_dependency 'shoulda', "~> 3.4.0"
  gem.add_development_dependency 'mocha', "~> 0.13.3"
  # shoulda-context blows up on ActiveSupport not being defined
  # on shoulda/context.rb:7
  # But then when you load active_support, shoulda-context decides
  # to load MiniTest
  gem.add_development_dependency 'test-unit', "~>3.2.5"
end
