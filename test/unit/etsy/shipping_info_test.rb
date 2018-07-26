require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ShippingInfoTest < Test::Unit::TestCase
    context "An instance of the ShippingInfo class" do
      setup do
        data = read_fixture('shipping_info/getShippingInfo.json')
        @shipping_info = ShippingInfo.new(data.first)
      end

      should "have an id" do
        @shipping_info.id.should == 212
      end

      should "have an title" do
        @shipping_info.primary_cost.should == "$9.99"
      end

      should "have an listing_id" do
        @shipping_info.listing_id.should == 14888443
      end
    end
  end
end
