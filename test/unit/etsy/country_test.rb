require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class CountryTest < Test::Unit::TestCase
    context "The Country class" do
      should "be findable by ISO3166-1 Alpha-2 codes" do
        united_states = mock
        united_states.stubs(:iso_country_code => "US")

        great_britain = mock
        great_britain.stubs(:iso_country_code => "GB")

        Country.stubs(:find_all).returns([great_britain, united_states])
        Country.find_by_alpha2("us").should == united_states
      end

      should "be findable by world bank country codes" do
        united_states = mock
        united_states.stubs(:world_bank_country_code => "USA")

        great_britain = mock
        great_britain.stubs(:world_bank_country_code => "GBR")

        Country.stubs(:find_all).returns([great_britain, united_states])
        Country.find_by_world_bank_country_code("gbr").should == great_britain
      end
    end

    context "An instance of the Country class" do
      setup do
        data = read_fixture('country/getCountry.json')
        @listing = Country.new(data.first)
      end

      should "have an id" do
        @listing.id.should == 55
      end

      should "have an iso_country_code" do
        @listing.iso_country_code.should == "AF"
      end

      should "have an world_bank_country_code" do
        @listing.world_bank_country_code.should == "AFG"
      end

      should "have an name" do
        @listing.name.should == "Afghanistan"
      end

      should "have an slug" do
        @listing.slug.should == "afghanistan"
      end

      should "have an lat" do
        @listing.lat.should == 33.78
      end

      should "have an lon" do
        @listing.lon.should == 66.17
      end
    end
  end
end
