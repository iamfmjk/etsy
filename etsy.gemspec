# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "etsy"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = "2012-06-21"
  s.email = "reaganpr@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/etsy", "lib/etsy/address.rb", "lib/etsy/basic_client.rb", "lib/etsy/category.rb", "lib/etsy/country.rb", "lib/etsy/image.rb", "lib/etsy/listing.rb", "lib/etsy/model.rb", "lib/etsy/payment_template.rb", "lib/etsy/profile.rb", "lib/etsy/request.rb", "lib/etsy/response.rb", "lib/etsy/secure_client.rb", "lib/etsy/shipping_template.rb", "lib/etsy/shop.rb", "lib/etsy/transaction.rb", "lib/etsy/user.rb", "lib/etsy/verification_request.rb", "lib/etsy/version.rb", "lib/etsy.rb", "test/fixtures", "test/fixtures/address", "test/fixtures/address/getUserAddresses.json", "test/fixtures/category", "test/fixtures/category/findAllSubCategoryChildren.json", "test/fixtures/category/findAllTopCategory.json", "test/fixtures/category/findAllTopCategory.single.json", "test/fixtures/category/findAllTopCategoryChildren.json", "test/fixtures/category/getCategory.multiple.json", "test/fixtures/category/getCategory.single.json", "test/fixtures/country", "test/fixtures/country/getCountry.json", "test/fixtures/image", "test/fixtures/image/findAllListingImages.json", "test/fixtures/listing", "test/fixtures/listing/findAllListingActive.category.json", "test/fixtures/listing/findAllShopListings.json", "test/fixtures/listing/getListing.multiple.json", "test/fixtures/listing/getListing.single.json", "test/fixtures/payment_template", "test/fixtures/payment_template/getPaymentTemplate.json", "test/fixtures/profile", "test/fixtures/profile/new.json", "test/fixtures/shipping_template", "test/fixtures/shipping_template/getShippingTemplate.json", "test/fixtures/shop", "test/fixtures/shop/findAllShop.json", "test/fixtures/shop/findAllShop.single.json", "test/fixtures/shop/getShop.multiple.json", "test/fixtures/shop/getShop.single.json", "test/fixtures/transaction", "test/fixtures/transaction/findAllShopTransactions.json", "test/fixtures/user", "test/fixtures/user/getUser.multiple.json", "test/fixtures/user/getUser.single.json", "test/fixtures/user/getUser.single.private.json", "test/fixtures/user/getUser.single.withProfile.json", "test/test_helper.rb", "test/unit", "test/unit/etsy", "test/unit/etsy/address_test.rb", "test/unit/etsy/basic_client_test.rb", "test/unit/etsy/category_test.rb", "test/unit/etsy/country_test.rb", "test/unit/etsy/image_test.rb", "test/unit/etsy/listing_test.rb", "test/unit/etsy/payment_template_test.rb", "test/unit/etsy/profile_test.rb", "test/unit/etsy/request_test.rb", "test/unit/etsy/response_test.rb", "test/unit/etsy/secure_client_test.rb", "test/unit/etsy/shipping_template_test.rb", "test/unit/etsy/shop_test.rb", "test/unit/etsy/transaction_test.rb", "test/unit/etsy/user_test.rb", "test/unit/etsy/verification_request_test.rb", "test/unit/etsy_test.rb"]
  s.homepage = "http://sneaq.net"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Provides a friendly ruby-like interface to the Etsy API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.5.0"])
      s.add_runtime_dependency(%q<oauth>, ["~> 0.4.0"])
    else
      s.add_dependency(%q<json>, [">= 1.5.0"])
      s.add_dependency(%q<oauth>, ["~> 0.4.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.5.0"])
    s.add_dependency(%q<oauth>, ["~> 0.4.0"])
  end
end
