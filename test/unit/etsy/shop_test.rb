require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ShopTest < Test::Unit::TestCase

    context "The Shop class" do

      should "be able to find a single shop" do
        shops = mock_request('/shops/littletjane', {}, 'Shop', 'getShop.single.json')
        Shop.find('littletjane').should == shops.first
      end

      should "be able to find multiple shops" do
        shops = mock_request('/shops/littletjane,reagent', {}, 'Shop', 'getShop.multiple.json')
        Shop.find('littletjane', 'reagent').should == shops
      end

      should "be able to find all shops" do
        shops = mock_request('/shops', {}, 'Shop', 'findAllShop.json')
        Shop.all.should == shops
      end

      should "return an array of shops if there is only 1 result returned" do
        shops = mock_request('/shops', {}, 'Shop', 'findAllShop.single.json')
        Shop.all.should == shops
      end

      should "allow a configurable limit when finding all shops" do
        shops = mock_request('/shops', {:limit => 100, :offset => 0}, 'Shop', 'findAllShop.json')
        Shop.all(:limit => 100).should == shops
      end

    end

    context "An instance of the Shop class" do

      context "with response data" do
        setup do
          data = read_fixture('shop/getShop.single.json')
          @shop = Shop.new(data.first)
        end

        should "have a value for :id" do
          @shop.id.should == 5500349
        end

        should "have a value for :user_id" do
          @shop.user_id.should == 5327518
        end

        should "have a value for :image_url" do
          @shop.image_url.should == "http://ny-image3.etsy.com/iusb_760x100.8484779.jpg"
        end

        should "have a value for :url" do
          @shop.url.should == "http://www.etsy.com/shop/littletjane"
        end

        should "have a value for :favorers_count" do
          @shop.favorers_count.should == 684
        end

        should "have a value for :active_listings_count" do
          @shop.active_listings_count.should == 0
        end

        should "have a value for :updated_at" do
          @shop.updated_at.should == Time.at(1274923984)
        end

        should "have a value for :created_at" do
          @shop.created_at.should == Time.at(1237430331)
        end

        should "have a value for :name" do
          @shop.name.should == "littletjane"
        end

        should "have a value for :title" do
          @shop.title.should == "a cute and crafty mix of handmade goods."
        end

        should "have a value for :message" do
          @shop.message.should == "thanks!"
        end

        should "have a value for :announcement" do
          @shop.announcement.should == "announcement"
        end

      end

      should "have a collection of listings" do
        shop = Shop.new
        shop.stubs(:id).with().returns(1)

        Listing.stubs(:find_all_by_shop_id).with(1, {}).returns('listings')

        shop.listings.should == 'listings'
      end
    end

  end
end
