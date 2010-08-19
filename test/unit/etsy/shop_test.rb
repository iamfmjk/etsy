require File.dirname(__FILE__) + '/../../test_helper'

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
        shops = mock_request('/shops', {:limit => 100}, 'Shop', 'findAllShop.json')
        Shop.all(:limit => 100).should == shops
      end

    end

    context "An instance of the Shop class" do

      when_populating Shop, :from => 'getShopDetails' do

        value_for :user_id,           :is => 5327518
        value_for :banner_image_url,  :is => 'http://ny-image0.etsy.com/iusb_760x100.6158980.jpg'
        value_for :listing_count,     :is => 13
        value_for :updated,           :is => 1239717723.36
        value_for :created,           :is => 1237430331.15
        value_for :name,              :is => 'littletjane'
        value_for :title,             :is => 'title text'
        value_for :message,           :is => 'message text'
        value_for :announcement,      :is => 'announcement text'

      end

      should "know the creation date" do
        shop = Shop.new
        shop.stubs(:created).with().returns(1237430331.15)

        shop.created_at.should == Time.at(1237430331.15)
      end

      should "know the update date" do
        shop = Shop.new
        shop.stubs(:updated).with().returns(1239717723.36)

        shop.updated_at.should == Time.at(1239717723.36)
      end

      should "have a collection of listings" do
        user_id = 123

        shop = Shop.new
        shop.expects(:user_id).with().returns(user_id)

        Listing.expects(:find_all_by_user_id).with(user_id).returns('listings')

        shop.listings.should == 'listings'
      end

    end

  end
end