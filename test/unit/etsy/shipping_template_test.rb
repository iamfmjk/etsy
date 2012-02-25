require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ShippingTemplateTest < Test::Unit::TestCase
    context "An instance of the ShippingTemplate class" do
      setup do
        data = read_fixture('shipping_template/getShippingTemplate.json')
        @shipping_template = ShippingTemplate.new(data.first)
      end

      should "have an id" do
        @shipping_template.id.should == 212
      end

      should "have an title" do
        @shipping_template.title.should == "Small Items"
      end

      should "have an user_id" do
        @shipping_template.user_id.should == 14888443
      end
    end
  end
end
