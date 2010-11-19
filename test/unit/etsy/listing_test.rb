require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ListingTest < Test::Unit::TestCase

    context "The Listing class" do

      should "be able to find a single listing" do
        listings = mock_request('/listings/123', {}, 'Listing', 'getListing.single.json')
        Listing.find(123).should == listings.first
      end

      should "be able to find multiple listings" do
        listings = mock_request('/listings/123,456', {}, 'Listing', 'getListing.multiple.json')
        Listing.find('123', '456').should == listings
      end

      context "within the scope of a shop" do

        should "be able to find the first 25 active listings" do
          listings = mock_request('/shops/1/listings/active', {}, 'Listing', 'findAllShopListings.json')
          Listing.find_all_by_shop_id(1).should == listings
        end

        should "be able to find expired listings" do
          listings = mock_request('/shops/1/listings/expired', {}, 'Listing', 'findAllShopListings.json')
          Listing.find_all_by_shop_id(1, :state => :expired).should == listings
        end

        should "be able to find inactive listings" do
          listings = mock_request('/shops/1/listings/inactive', {}, 'Listing', 'findAllShopListings.json')
          Listing.find_all_by_shop_id(1, :state => :inactive).should == listings
        end

        should "be able to find featured listings" do
          listings = mock_request('/shops/1/listings/featured', {}, 'Listing', 'findAllShopListings.json')
          Listing.find_all_by_shop_id(1, :state => :featured).should == listings
        end

        should "be able to find sold listings" do
          transaction_1 = stub(:listing_id => 1)
          transaction_2 = stub(:listing_id => 2)
          transaction_3 = stub(:listing_id => 1)

          transactions = [transaction_1, transaction_2, transaction_3]

          Transaction.stubs(:find_all_by_shop_id).with(1, {}).returns(transactions)
          Listing.stubs(:find).with([1, 2]).returns(['listings'])

          Listing.find_all_by_shop_id(1, :state => :sold).should == ['listings']
        end

        should "be able to override limit and offset" do
          options = {:limit => 100, :offset => 100}
          listings = mock_request('/shops/1/listings/active', options, 'Listing', 'findAllShopListings.json')
          Listing.find_all_by_shop_id(1, options).should == listings
        end

        should "raise an exception when calling with an invalid state" do
          options = {:state => :awesome}
          lambda { Listing.find_all_by_shop_id(1, options) }.should raise_error(ArgumentError)
        end

      end

    end

    context "An instance of the Listing class" do

      context "with response data" do
        setup do
          data = read_fixture('listing/findAllShopListings.json')
          @listing = Listing.new(data.first)
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

        should "have a value for :modified_at" do
          @listing.modified_at.should == Time.at(1287602289)
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

        should "have a value for :hue" do
          @listing.hue.should == 0
        end

        should "have a value for :saturation" do
          @listing.saturation.should == 0
        end

        should "have a value for :brightness" do
          @listing.brightness.should == 100
        end

        should "have a value for :black_and_white?" do
          @listing.black_and_white?.should == false
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
