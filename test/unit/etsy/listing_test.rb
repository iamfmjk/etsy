require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ListingTest < Test::Unit::TestCase

    context "The Listing class" do

      should "be able to find all listings for a shop" do
        listings = mock_request('/shops/1/listings/active', {}, 'Listing', 'findAllShopListingsActive.json')
        Listing.find_all_by_shop_id(1).should == listings
      end

    end

    context "An instance of the Listing class" do

      context "with response data" do
        setup do
          raw = raw_fixture_data('listing/findAllShopListingsActive.json')
          data = JSON.parse(raw)['results'][0]

          @listing = Listing.new(data)
        end

        should "have a value for :id" do
          @listing.id.should == 59495892
        end

        should "have a value for :state" do
          @listing.state.should == 'active'
        end

        should "have a value for :title" do
          @listing.title.should == "initials carved into tree love stamp"
        end

        should "have a value for :description" do
          @listing.description.should == "there! our initials are now carved deeply into this rough tree bark of memory"
        end

        should "have a value for :url" do
          @listing.url.should == "http://www.etsy.com/listing/59495892/initials-carved-into-tree-love-stamp"
        end

        should "have a value for :view_count" do
          @listing.view_count.should == 37
        end

        should "have a value for :created_at" do
          @listing.created_at.should == Time.at(1287602289)
        end

        should "have a value for :price" do
          @listing.price.should == "15.00"
        end

        should "have a value for :quantity" do
          @listing.quantity.should == 1
        end

        should "have a value for :currency" do
          @listing.currency.should == "USD"
        end

        should "have a value for :ending_at" do
          @listing.ending_at.should == Time.at(1298178000)
        end

        should "have a value for :tags" do
          @listing.tags.should == %w(tag_1 tag_2)
        end

        should "have a value for :materials" do
          @listing.materials.should == %w(material_1 material_2)
        end
      end

      %w(active removed sold_out expired alchemy).each do |state|
        should "know that the listing is #{state}" do
          listing = Listing.new
          listing.expects(:state).with().returns(state.sub('_', ''))

          listing.send("#{state}?".to_sym).should be(true)
        end

        should "know that the listing is not #{state}" do
          listing = Listing.new
          listing.expects(:state).with().returns(state.reverse)

          listing.send("#{state}?".to_sym).should be(false)
        end
      end

      should "have a collection of images" do
        listing = Listing.new
        listing.stubs(:id).with().returns(1)

        Image.stubs(:find_all_by_listing_id).with(1).returns('images')

        listing.images.should == 'images'
      end

      should "have a default image" do
        listing = Listing.new
        listing.stubs(:images).with().returns(%w(image_1 image_2))

        listing.image.should == 'image_1'
      end

    end
  end
end