# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{etsy}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2010-11-11}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/etsy", "lib/etsy/basic_client.rb", "lib/etsy/image.rb", "lib/etsy/listing.rb", "lib/etsy/model.rb", "lib/etsy/request.rb", "lib/etsy/response.rb", "lib/etsy/secure_client.rb", "lib/etsy/shop.rb", "lib/etsy/user.rb", "lib/etsy/verification_request.rb", "lib/etsy/version.rb", "lib/etsy.rb", "test/fixtures", "test/fixtures/image", "test/fixtures/image/findAllListingImages.json", "test/fixtures/listing", "test/fixtures/listing/findAllShopListingsActive.json", "test/fixtures/shop", "test/fixtures/shop/findAllShop.json", "test/fixtures/shop/findAllShop.single.json", "test/fixtures/shop/getShop.multiple.json", "test/fixtures/shop/getShop.single.json", "test/fixtures/user", "test/fixtures/user/getUser.multiple.json", "test/fixtures/user/getUser.single.json", "test/fixtures/user/getUser.single.private.json", "test/test_helper.rb", "test/unit", "test/unit/etsy", "test/unit/etsy/basic_client_test.rb", "test/unit/etsy/image_test.rb", "test/unit/etsy/listing_test.rb", "test/unit/etsy/request_test.rb", "test/unit/etsy/response_test.rb", "test/unit/etsy/secure_client_test.rb", "test/unit/etsy/shop_test.rb", "test/unit/etsy/user_test.rb", "test/unit/etsy/verification_request_test.rb", "test/unit/etsy_test.rb"]
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
