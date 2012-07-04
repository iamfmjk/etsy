# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.rubygems_version = "1.8.10"

  gem.authors       = ["Katrina Owen"]
  gem.authors       = ["Patrick Reagan", "Katrina Owen"]
  gem.email         = ["reaganpr@gmail.com", "katrina.owen@gmail.com"]
  gem.description   = %q{A friendly Ruby interface to the Etsy API}
  gem.summary       = %q{Provides a friendly ruby-like wrapper for the Etsy API}
  gem.homepage      = "http://github.com/kytrinyx/etsy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = "etsy"
  gem.require_paths = ["lib"]
  gem.version = "0.2.1"

  if gem.respond_to? :specification_version then
    gem.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      gem.add_runtime_dependency("json", [">= 1.5.0"])
      gem.add_runtime_dependency("oauth", ["~> 0.4.0"])
    else
      gem.add_dependency("json", [">= 1.5.0"])
      gem.add_dependency("oauth", ["~> 0.4.0"])
    end
  else
    gem.add_dependency("json", [">= 1.5.0"])
    gem.add_dependency("oauth", ["~> 0.4.0"])
  end

end
