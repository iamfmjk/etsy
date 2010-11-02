# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{etsy}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2010-10-11}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = Dir.glob("lib/**/*") + %w(README.rdoc Rakefile)
  s.homepage = %q{http://sneaq.net}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Provides a friendly ruby-like interface to the Etsy API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.4.0"])
      s.add_runtime_dependency(%q<oauth>, ["~> 0.4.0"])
    else
      s.add_dependency(%q<json>, ["~> 1.4.0"])
      s.add_dependency(%q<oauth>, ["~> 0.4.0"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.4.0"])
    s.add_dependency(%q<oauth>, ["~> 0.4.0"])
  end
end
