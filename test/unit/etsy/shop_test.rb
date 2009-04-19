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

        value_for :banner_image_url, :is => 'http://ny-image0.etsy.com/iusb_760x100.6158980.jpg'
        value_for :listing_count, :is => 13

      end

    end

  end
end