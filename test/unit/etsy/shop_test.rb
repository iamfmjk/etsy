require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class ShopTest < Test::Unit::TestCase

    describe "The Shop class" do

      it "should be able to find a shop by :user_id" do
        user_id  = 5327518
        response = mock_request_cycle :for => "/shops/#{user_id}", :data => 'getShopDetails'

        Shop.expects(:new).with(response.result).returns('shop')

        Shop.find_by_user_id(user_id).should == 'shop'
      end

    end

    describe "An instance of the Shop class" do

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
      
      it "should know the creation date" do
        shop = Shop.new
        shop.stubs(:created).with().returns(1237430331.15)
        
        shop.created_at.should == Time.at(1237430331.15)
      end
      
      it "should know the update date" do
        shop = Shop.new
        shop.stubs(:updated).with().returns(1239717723.36)
        
        shop.updated_at.should == Time.at(1239717723.36)
      end
      
      it "should have a collection of listings" do
        user_id = 123
        
        shop = Shop.new
        shop.expects(:user_id).with().returns(user_id)
        
        Listing.expects(:find_all_by_user_id).with(user_id).returns('listings')
        
        shop.listings.should == 'listings'
      end

    end

  end
end