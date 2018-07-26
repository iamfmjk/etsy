require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class BillPaymentTest < Test::Unit::TestCase
    context "An instance of the BillPayment class" do
      setup do
        data = read_fixture('bill_payment/getBillPayment.json')
        @bill_payment = BillPayment.new(data.first)
      end

      should "have an id" do
        @bill_payment.id.should == 212
      end

      should "have a type" do
        @bill_payment.type.should == "listing_id"
      end

      should "have an type_id" do
        @bill_payment.type_id.should == 14888443
      end
    end
  end
end
