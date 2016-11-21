require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ReceiptTest < Test::Unit::TestCase

    context "The Receipt class" do

      should "be able to find receipts for a shop" do
        receipts = mock_request('/shops/1/receipts', {'key' => 'value'}, 'Receipt', 'findAllShopReceipts.json')
        Receipt.find_all_by_shop_id(1, {'key' => 'value'}).should == receipts
      end

      should "be able to find receipts for a shop that also have a given status" do
        receipts = mock_request('/shops/1/receipts/open', {'key' => 'value'}, 'Receipt', 'findAllShopReceipts.json')
        Receipt.find_all_by_shop_id_and_status(1, 'open', {'key' => 'value'}).should == receipts
      end

    end

    context "An instance of the Receipt class" do

      context "with response data" do
        setup do
          data = read_fixture('receipt/findAllShopReceipts.json')
          @receipt = Receipt.new(data.first)
        end

        should "have a value for :id" do
          @receipt.id.should == 27230877
        end

        should "have :buyer_id" do
          @receipt.buyer_id.should == 12345
        end

        should "have :created_at" do
          @receipt.created_at.should == Time.at(1412206858)
        end

        should "have a value for :quantity" do
          @receipt.quantity.should == 5
        end

        should "have a value for :listing_id" do
          @receipt.listing_id.should == 123456
        end

        should "have a value for name" do
          @receipt.name.should == "Mike Taylor"
        end

        should "have a value for first_line" do
          @receipt.first_line.should == "123 Fun St"
        end

        should "have a value for second_line" do
          @receipt.second_line.should == "#3b"
        end

        should "have a value for city" do
          @receipt.city.should == "San Francisco"
        end

        should "have a value for state" do
          @receipt.state.should == "CA"
        end

        should "have a value for zip" do
          @receipt.zip.should == "94501"
        end

        should "have a value for country_id" do
          @receipt.country_id.should == 201
        end

        should "have a value for payment_email" do
          @receipt.payment_email.should == "foo@example.com"
        end

        should "have a value for buyer_email" do
          @receipt.buyer_email.should == "bar@example.com"
        end
      end

      should "know the buyer" do
        User.stubs(:find).with(1).returns('user')

        receipt = Receipt.new
        receipt.stubs(:buyer_id).with().returns(1)

        receipt.buyer.should == 'user'
      end

      should "have transaction information" do
        Transaction.stubs(:find_all_by_receipt_id).with(1, {:access_token=>'token',:access_secret=>'secret'}).returns('transactions')

        receipt = Receipt.new
        receipt.stubs(:id).with().returns(1)
        receipt.stubs(:token).with().returns('token')
        receipt.stubs(:secret).with().returns('secret')

        receipt.transactions.should == 'transactions'
      end
    end

  end
end