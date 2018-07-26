require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class BillChargeTest < Test::Unit::TestCase
    context "An instance of the BillCharge class" do
      setup do
        data = read_fixture('bill_charge/getBillCharge.json')
        @bill_charge = BillCharge.new(data.first)
      end

      should "have an id" do
        @bill_charge.id.should == 212
      end

      should "have a type" do
        @bill_charge.type.should == "listing_id"
      end

      should "have an type_id" do
        @bill_charge.type_id.should == 14888443
      end
    end
  end
end
